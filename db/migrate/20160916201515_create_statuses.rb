class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name
      t.string :type
      t.text :affect_text
      t.integer :duration
      t.string :duration_type
      t.string :bonus_method

      t.timestamps null: false
    end
  end
end
