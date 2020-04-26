class ParseService
  def self.start
    session = GoogleDrive::Session.from_config(Rails.env.development? ? 'google-drive-json.json' : ENV['GOOGLE_APPLICATION_CREDENTIALS'])
    file = session.file_by_title("games_mp.log")
    file.download_to_file("#{Rails.root}/games_mp.log")
    last_line = Setting.first.last_line || 0
    File.open("#{Rails.root}/games_mp.log").each_with_index do |line, i|
      next if i < last_line
      puts line
      puts i
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
      elsif line.include?("J;0;") || line.include?("Q;0;")
        scanned = line.split(';')
        p scanned
        time_string = scanned.first.split(' ').first
        action_type = scanned.first.split(' ').last == 'J' ? :join : :quit
        damaging_user_id = if Nickname.find_by_name(scanned.last.strip)
          Nickname.find_by_name(scanned.last.strip).user_id
        else
          user = User.new(email: "#{scanned.last.strip}@user.com", first_name: scanned.last.strip, last_name: '-', password: '11111111',
                         password_confirmation: '11111111', role: :player)
          if user.save
            user.nicknames.create(name: scanned.last.strip)
            user.id
          end
        end
        Action.create(action_type: action_type, damaging_user_id: damaging_user_id, time_string: time_string, round_id: Round.last.id)
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
        action_type = scanned.first.include?('D') ? :damage : :kill
        weapon_id = Weapon.find_by_name(scanned[9].downcase)&.id
        time_string = scanned.first.split(' ').first
        action_damagetype = scanned.last.strip
        team_damage = !Round.last.dm? && scanned[3] == scanned[7] && scanned[4] != scanned[8]
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
            Action.create(action_type: team_damage ? :team_damage : (scanned.first.include?('D') ? :damage : :kill), damaged_user_id: damaged_user_id,
                          damaging_user_id: damaging_user_id, action_damagetype: :grenade, time_string: time_string,
                          damage: damage, weapon_id: weapon_id, round_id: Round.last.id)
          end
        elsif scanned[-2] == 'MOD_EXPLOSIVE'
          Action.create(action_type: scanned.first.include?('D') ? :self_damage : :suicide, damaged_user_id: damaged_user_id,
                        action_damagetype: :explosive, time_string: time_string,
                        damage: damage, round_id: Round.last.id)
        elsif scanned[-2] == 'MOD_MELEE'
          Action.create(action_type: action_type, damaged_user_id: damaged_user_id, damaging_user_id: damaging_user_id,
                        weapon_id: weapon_id, action_damagetype: :melee,
                        time_string: time_string, damage: damage, round_id: Round.last.id)
        elsif scanned[-2] == 'MOD_PROJECTILE_SPLASH' || scanned[-2] == 'MOD_PROJECTILE'
          Action.create(action_type: team_damage ? :team_damage : action_type, damaged_user_id: damaged_user_id, damaging_user_id: damaging_user_id,
                        weapon_id: weapon_id, action_damagetype: :launcher,
                        time_string: time_string, damage: damage, round_id: Round.last.id)
        elsif scanned[-2] == 'MOD_TRIGGER_HURT'
          Action.create(action_type: :self_damage, damaged_user_id: damaged_user_id,
                        action_damagetype: :other, time_string: time_string, damage: damage, round_id: Round.last.id)
        else
          Action.create(action_type: team_damage ? :team_damage : action_type, damaged_user_id: damaged_user_id, damaging_user_id: damaging_user_id,
                        weapon_id: weapon_id, action_damagetype: action_damagetype,
                        time_string: time_string, damage: damage, round_id: Round.last.id)
        end
      elsif line.include? "ShutdownGame"
        scanned = line.scan(/[\w'-]+/)
        p scanned
        time_string_end = scanned.first(2).join(':')
        Round.last.update(time_string_end: time_string_end)
      end
    end
    Setting.first.update(last_line: File.foreach("#{Rails.root}/games_mp.log").inject(0) {|c, line| c+1})
  end

  def self.get_nicknames
    last_line = Setting.first.last_line || 0
    File.open("#{Rails.root}/games_mp.log").each_with_index do |line, i|
      next if i < last_line
      line.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      if line.include?('D;0;') || line.include?('K;0;')
        scanned = line.split(';')
        p scanned
        User.first.nicknames.create(name: scanned[4])
        User.first.nicknames.create(name: scanned[8])
      end
    end
  end
end