class AddUserIdToCardGroup < ActiveRecord::Migration
  def change
    add_column :card_groups, :user_id, :integer
  end
end
