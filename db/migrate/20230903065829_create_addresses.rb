class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :address_line
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.float :latitude
      t.float :longitude
      t.boolean :is_primary
      t.string :name
      t.references :user

      t.timestamps
    end
  end
end
