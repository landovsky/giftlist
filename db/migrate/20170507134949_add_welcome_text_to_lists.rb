class AddWelcomeTextToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :welcome_text, :text
  end
end
