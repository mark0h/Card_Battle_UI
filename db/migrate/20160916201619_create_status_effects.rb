class CreateStatusEffects < ActiveRecord::Migration
  def change
    create_table :status_effects do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :status_id
      t.integer :remaining

      t.timestamps null: false
    end
  end
end
