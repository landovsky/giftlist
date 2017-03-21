class CreateGifts < ActiveRecord::Migration[5.0]
  def change
    create_table :gifts do |t|
      t.belongs_to :list, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.string :name
      t.text :description
      t.string :price_range

      t.timestamps
    end
  end
end
