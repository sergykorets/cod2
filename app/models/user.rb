class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "200x200#", thumb: "100x100#" }, default_url: "/images/missing.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  has_many :damaged_actions, class_name: 'Action', foreign_key: :damaged_user_id
  has_many :damaging_actions, class_name: 'Action', foreign_key: :damaging_user_id
  #has_many :damaged_users, class_name: 'User', through: :damaged_actions
  #has_many :damaging_users, class_name: 'User', through: :damaging_actions
  has_many :weapons, through: :damaging_actions
  has_many :nicknames
  has_many :round_actions
  has_many :rounds, -> { distinct }, through: :round_actions


  enum role: [:player, :admin]

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def name
    "#{first_name} #{last_name}"
  end

  def average_damage
    actions = damaging_actions.where(action_type: [:kill, :damage]).where.not(action_damagetype: [:grenade, :launcher])
    actions.any? ? (actions.sum(:damage).to_d / actions.count.to_d).round(2) : 0
  end

  def favorite_body_targets
    damaging_actions.where(action_type: [:kill, :damage]).where.not(action_damagetype: [:grenade, :launcher]).group(:action_damagetype).count
  end

  def favorite_body_target
    actions = favorite_body_targets
    actions.key(actions.values.max)
  end

  def favorite_weapon
    actions = weapons.group(:name).count
    actions.key(actions.values.max)
  end

  def headshots
    actions = damaging_actions.where(action_type: [:kill, :damage]).where.not(action_damagetype: [:grenade, :launcher, :melee]).count.to_d
    headshots = damaging_actions.where(action_type: [:kill, :damage], action_damagetype: :head).count.to_d
    ((headshots / actions) * 100).round(2)
  end

  def average_kills_per_minute
    actions = damaging_actions.where(action_type: :kill).count.to_d
    total_minutes = total_in_game.to_d / 60.0
    (actions / total_minutes).round(2)
  end

  def kill_death_rate
    kill_actions = damaging_actions.where(action_type: :kill).count.to_d
    death_actions = damaged_actions.where(action_type: :kill).count.to_d
    ((kill_actions / death_actions) * 100).round(2)
  end

  def average_suicides_per_round
    plays = rounds.count.to_d
    suicides = damaged_actions.suicide.count.to_d
    ((suicides / plays) * 100).round(2)
  end

  def average_self_damage_per_round
    plays = rounds.count.to_d
    self_damages = damaged_actions.self_damage.sum(:damage).to_d
    ((self_damages / plays)).round(2)
  end

  def grenades
    actions = damaging_actions.where(action_type: [:kill, :damage], action_damagetype: :grenade).sum(:damage).to_d
    plays = rounds.count.to_d
    ((actions / plays)).round(2)
  end

  def team_damage_per_round
    actions = damaging_actions.where(action_type: :team_damage).sum(:damage).to_d
    plays = rounds.where.not(round_type: :dm).count.to_d
    ((actions / plays)).round(2)
  end

  def rating
    stats['average_damage'].to_d + stats['headshots'].to_d*5.0 + stats['kill_death_rate'].to_d/2.0 +
    stats['average_kills_per_minute'].to_d*100.0 + stats['total_in_game'].to_d/10000.0 + stats['grenades'].to_d/5.0 -
    stats['average_suicides_per_round'].to_d - stats['average_self_damage_per_round'].to_d - stats['team_damage_per_round'].to_d || 0
  end

  def total_in_game
    times = []
    rounds.each do |round|
      time_end = round.time_end
      has_quit_actions = round.round_actions.where(user_id: id).quit.any?
      if has_quit_actions
        hash = { connect: [], quit: [] }.with_indifferent_access
        actions = round.round_actions.where(user_id: id)
        actions.each_with_index do |round_action, i|
          if i > 0 && actions[i-1].round_action_type != round_action.round_action_type
            hash[round_action.round_action_type] << round_action.time
          end
        end
        round_times = []
        hash[:quit] << time_end if hash[:connect].size > hash[:quit].size
        hash[:connect].size.times do |i|
          round_times << hash[:quit][i] - hash[:connect][i]
        end
        times << round_times.sum
      else
        times << time_end - round.round_actions.connect.first.time
      end
    end
    times.sum
  end

end