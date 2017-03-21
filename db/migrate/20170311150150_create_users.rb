class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.integer :role
      t.string :name
      t.string :surname
      t.integer :sex
      t.date :dob
      t.date :birth_year
      t.string :password_digest

      t.timestamps
    end
  end
end
