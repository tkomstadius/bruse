class RemoveDownloadHashFromUserAndAddDownloadHashToBruseFile < ActiveRecord::Migration
  def change
    remove_column :users, :download_hash, :string
  end
  def change
    add_column :bruse_files, :download_hash, :string
  end
end
