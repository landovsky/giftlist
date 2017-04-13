class AddOccasionDataToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :occasion_data, :string
  end
end
