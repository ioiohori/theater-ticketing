class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.monetize :price
      t.integer :status
      t.string :reference
      t.string :payment_method
      t.string :response_id
      t.json :full_response

      t.timestamps
    end

    add_index :payments, :reference
  end
end
