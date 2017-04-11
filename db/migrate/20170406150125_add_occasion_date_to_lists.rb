class AddOccasionDateToLists < ActiveRecord::Migration[5.0]
  def self.up
    add_column :lists, :occasion_date, :date
  end
  
  def self.donw
    remove_column :lists, :occasion_date
  end
end
