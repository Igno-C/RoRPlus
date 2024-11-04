class CreateQuotes < ActiveRecord::Migration[7.2]
  def change
    create_table :quotes do |t|
      t.datetime :timestamp
      t.integer :price
      t.references :ticker, null: false, foreign_key: true

      t.timestamps
    end
  end
end
