class RenameTypeColumnStatusEffects < ActiveRecord::Migration
  def change
    rename_column :statuses, :type, :status_type
  end
end
