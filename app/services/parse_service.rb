class ParseService
  def self.start
    last_line = Setting.first.last_line || 0
    File.open("/Users/vandal/Projects/cod2/games_mp.log").each_with_index do |line, i|
      next if i < last_line
      puts line
      line.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      if line.include? "InitGame"
        scanned = line.scan(/[\w'-]+/)
        p scanned
        gametype_index = scanned.index { |x| x.include?('g_gametype') }
        location_index = scanned.index { |x| x.include?('mapname') }
        round_type = scanned[gametype_index + 1]
        location = scanned[location_index + 1]
        time_string_start = scanned.first(2).join(':')
        Round.create(time_string_start: time_string_start, location: location, round_type: round_type)
      elsif line.include?('D;0;') || line.include?('K;0;')
        scanned = line.split(';')
        p scanned
        damaged_user_id = if Nickname.find_by_name(scanned[4])
          Nickname.find_by_name(scanned[4]).user_id
        else
          user = User.new(email: "#{scanned[4]}@user.com", first_name: scanned[4], last_name: '-', password: '11111111',
                      password_confirmation: '11111111', role: :player)
          if user.save
            user.nicknames.create(name: scanned[4])
            user.id
          end
        end
        damaging_user_id = if Nickname.find_by_name(scanned[8])
          Nickname.find_by_name(scanned[8]).user_id
        else
          user = User.new(email: "#{scanned[8]}@user.com", first_name: scanned[8], last_name: '-', password: '11111111',
                      password_confirmation: '11111111', role: :player)
          if user.save
            user.nicknames.create(name: scanned[8])
            user.id
          end
        end
        damage = scanned[-3]
        if scanned.last.strip != 'none'
          action_type = scanned.first.include?('D') ? :damage : :kill
          weapon_id = Weapon.find_by_name(scanned[9].downcase).id
          time_string = scanned.first.split(' ').first
          action_damagetype = scanned.last.strip
          Action.create(action_type: action_type, damaged_user_id: damaged_user_id, damaging_user_id: damaging_user_id,
                        weapon_id: weapon_id, action_damagetype: scanned[-2] == 'MOD_MELEE' ? :melee : action_damagetype,
                        time_string: time_string, damage: damage, round_id: Round.last.id)
        else
          time_string = scanned.first.split(' ').first
          if scanned[-2] == 'MOD_FALLING'
            Action.create(action_type: :self_damage, damaged_user_id: damaged_user_id,
                          action_damagetype: :other, time_string: time_string,
                          damage: damage, round_id: Round.last.id)
          elsif scanned[-2] == 'MOD_SUICIDE'
            Action.create(action_type: :suicide, damaged_user_id: damaged_user_id,
                          action_damagetype: :other, time_string: time_string, round_id: Round.last.id)
          elsif scanned[-2] == 'MOD_GRENADE_SPLASH'
            weapon_id = Weapon.find_by_name(scanned[9].downcase).id
            if scanned[4] == scanned[8]
              Action.create(action_type: scanned.first.include?('D') ? :self_damage : :suicide, damaged_user_id: damaged_user_id,
                            damage: damage, weapon_id: weapon_id, action_damagetype: :grenade, time_string: time_string,
                            round_id: Round.last.id)
            else
              Action.create(action_type: scanned.first.include?('D') ? :damage : :kill, damaged_user_id: damaged_user_id,
                            damaging_user_id: damaging_user_id, action_damagetype: :grenade, time_string: time_string,
                            damage: damage, weapon_id: weapon_id, round_id: Round.last.id)
            end
          elsif scanned[-2] == 'MOD_EXPLOSIVE'
            Action.create(action_type: scanned.first.include?('D') ? :self_damage : :suicide, damaged_user_id: damaged_user_id,
                          action_damagetype: :explosive, time_string: time_string,
                          damage: damage, round_id: Round.last.id)
          end
        end
      elsif line.include? "ShutdownGame"
        scanned = line.scan(/[\w'-]+/)
        p scanned
        time_string_end = scanned.first(2).join(':')
        Round.last.update(time_string_end: time_string_end)
      end
    end
    Setting.first.update(last_line: File.foreach("/Users/vandal/Projects/cod2/games_mp.log").inject(0) {|c, line| c+1})
  end

  def self.get_nicknames
    last_line = Setting.first.last_line || 0
    File.open("/Users/vandal/Projects/cod2/games_mp.log").each_with_index do |line, i|
      next if i < last_line
      line.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      if line.include?('D;0;') || line.include?('K;0;')
        scanned = line.split(';')
        p scanned
        User.last.nicknames.create(name: scanned[4])
        User.last.nicknames.create(name: scanned[8])
      end
    end
  end
end