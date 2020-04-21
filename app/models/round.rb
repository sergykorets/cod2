class Round < ApplicationRecord
  has_many :actions
  enum round_type: [:dm, :tdm, :ctf, :hq, :sd]
end