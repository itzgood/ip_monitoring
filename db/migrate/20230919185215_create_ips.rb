class CreateIps < ActiveRecord::Migration[7.0]
  def change
    create_table :ips do |t|
      t.string :address, null: false, unique: true
      t.boolean :enabled, default: false
      t.timestamps
    end
  end
end
