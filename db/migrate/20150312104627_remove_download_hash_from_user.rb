class RemoveDownloadHashFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :download_hash
  end
end
