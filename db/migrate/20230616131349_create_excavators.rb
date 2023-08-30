class CreateExcavators < ActiveRecord::Migration[7.0]
  def change
    create_table :excavators do |t|
      t.string :company_name
      t.string :contact_name
      t.string :address
      t.string :city
      t.string :state
      t.string :email, null: false
      t.integer :phone_no, null: false
      t.integer :zip
      t.boolean :crew_on_site, default: false
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
    end

    add_index :excavators, :email, unique: true
  end
end


