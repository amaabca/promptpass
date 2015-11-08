class AddDecryptionAttemptToSecret < ActiveRecord::Migration
  def change
    add_column :secrets, :decryption_attempt, :integer, default: 0
  end
end
