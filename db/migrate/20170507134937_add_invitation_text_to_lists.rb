class AddInvitationTextToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :invitation_text, :text
  end
end
