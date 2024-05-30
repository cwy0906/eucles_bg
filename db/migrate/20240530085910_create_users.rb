class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: false  do |t|
      t.string  :id_hash,   null: false, primary_key: true
      t.string  :email,     null: false
      t.string  :nickname
      t.string  :user_name, null: false
      t.string  :password_digest
      t.integer :role,      default: 2
      t.timestamps

      t.index :user_name, unique: true
    end
  end
end
