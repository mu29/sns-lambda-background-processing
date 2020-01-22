class CreatePendingJob < ActiveRecord::Migration[5.2]
  def change
    create_table :pending_jobs do |t|
      t.string :klass
      t.text :params
      t.datetime :wait_until

      t.timestamps
    end
  end
end
