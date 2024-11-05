class CreateTickers < ActiveRecord::Migration[7.2]
  def change
    create_table :tickers do |t|
      t.string :name, limit: 4

      t.timestamps
    end
    add_index :tickers, :name, unique: true
  end
end
