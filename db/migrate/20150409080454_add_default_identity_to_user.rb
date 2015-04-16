class AddDefaultIdentityToUser < ActiveRecord::Migration
  def change
    add_column :users, :default_identity, :integer
  end
end
