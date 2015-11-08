class CreateSenders < ActiveRecord::Migration
  def change
    create_table :senders do |t|
      t.string     :email
      t.string     :token, index: true
      t.references :secret, index: true

      t.timestamps
    end
  end
end
