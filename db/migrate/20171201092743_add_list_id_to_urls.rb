class AddListIdToUrls < ActiveRecord::Migration[5.0]
  def change
    add_column :urls, :list_id, :integer, null: true
  end
end
