class CreateSecrets < ActiveRecord::Migration
  def change
    create_table :secrets do |t|
      t.text :encrypted_body

      t.timestamps
    end
  end
end
