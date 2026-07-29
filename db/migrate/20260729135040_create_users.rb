class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false, index: { unique: true }
      t.string :role, null: false, default: 'employee'
      t.timestamps
    end
  end
end
