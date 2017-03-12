class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.integer :status
      t.string :name
      t.string :surname
      t.integer :sex
      t.date :dob
      t.date :birth_year

      t.timestamps
    end
  end
end
