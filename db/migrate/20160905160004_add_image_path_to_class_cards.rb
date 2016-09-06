class AddImagePathToClassCards < ActiveRecord::Migration
  def change
    add_column  :class_cards, :image_path, :string
  end
end
