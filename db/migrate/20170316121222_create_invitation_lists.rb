class CreateInvitationLists < ActiveRecord::Migration[5.0]
  def change
    create_table :invitation_lists do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :list, foreign_key: true

      t.timestamps
    end
  end
end
