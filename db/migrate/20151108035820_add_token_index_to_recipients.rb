class AddTokenIndexToRecipients < ActiveRecord::Migration
  def change
    add_index :recipients, :token
  end
end
