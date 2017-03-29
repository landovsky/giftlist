class CreateUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :urls do |t|
      t.belongs_to :gift, foreign_key: true
      t.string :digest
      t.string :data

      t.timestamps
    end
  end
end
