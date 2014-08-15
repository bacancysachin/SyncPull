class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :request_id
      t.datetime :requested_at
      t.float :lat
      t.float :lng
      t.integer :year_built
      t.string :usecode
      t.datetime :last_sold_on
      t.float :last_sold_price
      t.integer :tax_assesment_year
      t.float :tax_assesment_amount
      t.float :zestimate_price
      t.integer :zestimate_value_range_high
      t.integer :zestimate_value_range_low
      t.datetime :zastimate_last_updated_on
      t.integer :lot_size
      t.integer :house_size
      t.integer :zpid

      t.timestamps
    end
    add_index :properties, [:lat, :lng, :request_id]
  end
end