class Round < ApplicationRecord
  has_many :actions
  has_many :round_actions
  enum round_type: [:dm, :tdm, :ctf, :hq, :sd]
end