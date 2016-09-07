class AddImagePathToSkillCard < ActiveRecord::Migration
  def change
    add_column :skill_cards, :image_path, :string
  end
end
