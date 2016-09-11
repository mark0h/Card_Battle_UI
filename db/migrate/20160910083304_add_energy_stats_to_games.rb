class AddEnergyStatsToGames < ActiveRecord::Migration
  def change
    add_column :games, :p1_energy, :integer
    add_column :games, :p2_energy, :integer
  end
end
