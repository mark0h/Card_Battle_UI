class Game < ActiveRecord::Base
  belongs_to :user
  has_many :card_groups
end
