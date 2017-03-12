class CreateGiftLists < ActiveRecord::Migration[5.0]
  def change
    create_table :gift_lists do |t|
      t.belongs_to :user, foreign_key: true
      t.string :occasion
      t.integer :occasion_of

      t.timestamps
    end
  end
end
