class ChangeColumnTypeInLists < ActiveRecord::Migration[5.0]
  def change
    remove_column :lists, :occasion
    add_column :lists, :occasion, :integer
  end
end
