class AddDurationTypeToStatuseffects < ActiveRecord::Migration
  def change
    add_column :status_effects, :duration_type, :string
  end
end
