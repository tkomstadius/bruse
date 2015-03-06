class RenameTypeToFiletype < ActiveRecord::Migration
  def change
  	rename_column :bruse_files, :type, :filetype
  end
end
