class Nickname < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :name
end