class CreateBruseFileTag < ActiveRecord::Migration
  def change
    create_table :bruse_file_tags do |t|
    	t.integer :bruseFile_id
    	t.integer :tag_id
    end
  end
end
