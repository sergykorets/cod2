class Action < ApplicationRecord
  belongs_to :damaged_user, class_name: 'User', foreign_key: :damaged_user_id, optional: true
  belongs_to :damaging_user, class_name: 'User', foreign_key: :damaging_user_id, optional: true
  belongs_to :weapon, optional: true
  belongs_to :round

  enum action_type: [:kill, :damage, :suicide, :self_damage, :join, :quit]
  enum action_damagetype: [:head, :neck, :torso_upper, :torso_lower, :right_hand, :left_hand, :left_foot, :right_foot,
                         :right_arm_upper, :left_arm_upper, :right_arm_lower, :left_arm_lower,
                         :right_leg_upper, :left_leg_upper, :right_leg_lower, :left_leg_lower, :other, :grenade, :melee, :explosive]
end