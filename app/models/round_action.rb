class RoundAction < ApplicationRecord
  belongs_to :round
  belongs_to :user
  enum round_action_type: [:connect, :quit]
end