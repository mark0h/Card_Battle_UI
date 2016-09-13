class CreateCardPriorities < ActiveRecord::Migration
  def change
    create_table :card_priorities do |t|
      t.integer :class_id
      t.integer :card_id
      t.integer :opponent_class_id
      t.integer :energy_cost
      t.integer :priority

      t.timestamps null: false
    end
  end
end
