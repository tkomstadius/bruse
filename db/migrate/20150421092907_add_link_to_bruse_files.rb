class AddLinkToBruseFiles < ActiveRecord::Migration
  def change
    add_column :bruse_files, :link, :string
  end
end
