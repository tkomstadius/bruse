class AddDownloadHashToUser < ActiveRecord::Migration
  def change
    add_column :users, :download_hash, :string
  end
end
