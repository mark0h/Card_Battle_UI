class CardPriority < ActiveRecord::Base
  validates :card_id, presence: true, uniqueness: {case_sensitive: false}
end
