class AddEncryptionSaltToSecrets < ActiveRecord::Migration
  def change
    add_column :secrets, :encryption_salt, :string
  end
end
