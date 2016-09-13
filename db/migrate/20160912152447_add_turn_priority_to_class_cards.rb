class AddTurnPriorityToClassCards < ActiveRecord::Migration
  def change
    add_column :class_cards, :turn_priority, :integer
  end
end
