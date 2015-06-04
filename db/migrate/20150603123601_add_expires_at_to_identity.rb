class AddExpiresAtToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :expires_at, :integer
  end
end
