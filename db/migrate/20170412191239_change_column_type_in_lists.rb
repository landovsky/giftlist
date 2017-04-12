class ChangeColumnTypeInLists < ActiveRecord::Migration[5.0]
  def change
    change_table :lists do |t|
      t.change :occasion, :integer
    end
  end
end
