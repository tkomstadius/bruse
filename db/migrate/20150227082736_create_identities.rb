class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true
      t.string :token
      t.string :service

      t.timestamps null: false
    end
    add_foreign_key :identities, :users
  end
end
