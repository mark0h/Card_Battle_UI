class CreateClassCards < ActiveRecord::Migration
  def change
    create_table :class_cards do |t|
      t.string :name
      t.integer :health
      t.string :base_stat
      t.integer :mp
      t.integer :rp
      t.integer :ms
      t.integer :rs
      t.text :notes
      t.string :ally

      t.timestamps null: false
    end
  end
end
