class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "200x200#", thumb: "100x100#" }, default_url: "/images/missing.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  has_many :demaged_actions, class_name: 'Action', foreign_key: :damaged_user_id
  has_many :demaging_actions, class_name: 'Action', foreign_key: :damaging_user_id
  #has_many :damaged_users, class_name: 'User', through: :demaged_actions
  #has_many :demaging_users, class_name: 'User', through: :demaging_actions
  has_many :weapons, through: :demaging_actions
  has_many :nicknames
  has_many :rounds, -> { distinct }, through: :demaging_actions

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
    actions = demaging_actions.where(action_type: [:kill, :damage]).where.not(action_damagetype: [:grenade, :launcher])
    actions.any? ? (actions.sum(:damage).to_d / actions.count.to_d).round(2) : 0
  end

  def favorite_body_targets
    demaging_actions.where(action_type: [:kill, :damage]).where.not(action_damagetype: [:grenade, :launcher]).group(:action_damagetype).count
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
    actions = demaging_actions.where(action_type: [:kill, :damage]).where.not(action_damagetype: [:grenade, :launcher, :melee]).count.to_d
    headshots = demaging_actions.where(action_type: [:kill, :damage], action_damagetype: :head).count.to_d
    ((headshots / actions) * 100).round(2)
  end

  def average_kills_per_round
    actions = demaging_actions.joins(:round).where(actions: {action_type: :kill}).where.not(rounds: {round_type: :sd}).count.to_d
    plays = rounds.where.not(round_type: :sd).count.to_d
    (actions / plays).round(2)
  end

  def kill_death_rate
    kill_actions = demaging_actions.where(action_type: :kill).count.to_d
    death_actions = demaged_actions.where(action_type: :kill).count.to_d
    ((kill_actions / death_actions) * 100).round(2)
  end

  def average_suicides_per_round
    plays = rounds.count.to_d
    suicides = demaged_actions.suicide.count.to_d
    ((suicides / plays) * 100).round(2)
  end

  def average_self_damage_per_round
    plays = rounds.count.to_d
    self_damages = demaged_actions.self_damage.sum(:damage).to_d
    ((self_damages / plays)).round(2)
  end

  def grenades
    actions = demaging_actions.where(action_type: [:kill, :damage], action_damagetype: :grenade).sum(:damage).to_d
    plays = rounds.count.to_d
    ((actions / plays)).round(2)
  end

  def team_damage_per_round
    actions = demaging_actions.where(action_type: :team_damage).sum(:damage).to_d
    plays = rounds.where.not(round_type: :dm).count.to_d
    ((actions / plays)).round(2)
  end

  def rating
    average_damage + headshots*5 + kill_death_rate/2 + average_kills_per_round*5 + rounds.count/10 + grenades/5 - average_suicides_per_round - average_self_damage_per_round - team_damage_per_round || 0
  end

end