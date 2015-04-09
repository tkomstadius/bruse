class AddOwnPasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :own_password, :boolean, :default => true
  end
end
