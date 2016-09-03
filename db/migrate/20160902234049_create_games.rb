class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :whose_turn
      t.integer :p1_health
      t.integer :p2_health
      t.integer :round

      t.timestamps null: false
    end
  end
end
