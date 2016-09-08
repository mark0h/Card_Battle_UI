class AddClassIdToCardGroup < ActiveRecord::Migration
  def change
    add_column :card_groups, :class_id, :integer
  end
end
