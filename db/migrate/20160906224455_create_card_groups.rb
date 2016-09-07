class CreateCardGroups < ActiveRecord::Migration
  def change
    create_table :card_groups do |t|
      t.integer :game_id
      t.integer :card_id
      t.integer :cooldown_remaining
      t.boolean :current_hand_card
      t.boolean :deck_card
      t.boolean :cooldown_card
      t.boolean :inplay_card
    end
  end
end
