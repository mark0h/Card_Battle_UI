class AddImageIdToClassCards < ActiveRecord::Migration
  def change
    add_column :class_cards, :image_id, :integer
  end
end
