class AddUserAndOpponentToGames < ActiveRecord::Migration
  def change
    add_column :games, :user_id, :integer
    add_column :games, :opponent_id, :integer
  end
end
