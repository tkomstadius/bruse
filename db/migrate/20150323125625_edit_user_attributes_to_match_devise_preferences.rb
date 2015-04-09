class EditUserAttributesToMatchDevisePreferences < ActiveRecord::Migration
  def change
    change_column :users, :email, :string, null: false, default: ""
    change_column :users, :sign_in_count, :integer, default: 0, null: false
  end
end
