class AddImagePathToCardGroup < ActiveRecord::Migration
  def change
    add_column :card_groups, :image_path, :string
  end
end
