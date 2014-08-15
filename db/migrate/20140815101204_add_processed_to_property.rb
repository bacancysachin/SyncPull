class AddProcessedToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :processed, :boolean, after: :zpid
    change_column :properties, :house_size, :string
  end
end