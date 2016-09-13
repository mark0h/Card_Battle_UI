class RemoveCardPriorities < ActiveRecord::Migration
  def change
    drop_table :card_priorities
  end
end
