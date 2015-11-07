class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.string        :phone_number
      t.string        :email
      t.references    :secret, index: true

      t.timestamps
    end
  end
end
