class RenameDefaultIdentityToDefaultIdentityId < ActiveRecord::Migration
  def change
    rename_column :users, :default_identity, :default_identity_id
  end
end
