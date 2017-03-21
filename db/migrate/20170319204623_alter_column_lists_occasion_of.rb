class AlterColumnListsOccasionOf < ActiveRecord::Migration[5.0]
  def self.up
    change_table :lists do |t|
      t.change :occasion_of, :string
      t.change :occasion, :string
    end
  end

  def self.down
    change_table :lists do |t|
      t.change :occasion_of, :integer
      t.change :occasion, :integer
    end
  end
end
