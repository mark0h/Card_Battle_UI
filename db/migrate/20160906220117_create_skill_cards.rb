class CreateSkillCards < ActiveRecord::Migration
  def change
    create_table :skill_cards do |t|
      t.string :name
      t.integer :class_id
      t.string :card_type
      t.integer :cost
      t.string :attack_type
      t.integer :attack_targets
      t.integer :damage
      t.string :description
      t.string :bonus_method
      t.integer :buff_id
      t.integer :debuff_id
      t.integer :cooldown

      t.timestamps null: false
    end
    add_index :skill_cards, :name
    add_index :skill_cards, :class_id
  end
end
