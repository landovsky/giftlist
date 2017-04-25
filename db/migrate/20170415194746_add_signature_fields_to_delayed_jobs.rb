class AddSignatureFieldsToDelayedJobs < ActiveRecord::Migration[5.0]
  def up
    add_column :delayed_jobs, :signature, :string
    add_column :delayed_jobs, :args, :text
  end
  
  def down
    remove_column :delayed_jobs, :signature
    remove_column :delayed_jobs, :args
  end 
end