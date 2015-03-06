class RenameFiletagRelationTable < ActiveRecord::Migration
  def change
  	rename_column :bruse_file_tags, :bruseFile_id, :bruse_file_id
  	rename_table :bruse_file_tags, :bruse_files_tags
  end
end
