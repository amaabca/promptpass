class AddExpiryToSecret < ActiveRecord::Migration
  def change
    add_column :secrets, :expiry, :datetime, default: nil
  end
end
