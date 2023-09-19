class CreatePings < ActiveRecord::Migration[7.0]
  def change
    create_table :pings do |t|
      t.references :ip, null: false, foreign_key: true
      t.decimal :rtt, precision: 10, scale: 4
      t.boolean :success, null: false
      t.timestamps
    end
  end
end
