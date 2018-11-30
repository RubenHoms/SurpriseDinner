class CreateScheduledJobs < ActiveRecord::Migration
  def change
    create_table :scheduled_jobs do |t|
      t.string :job_id
      t.string :job_name
      t.datetime :at
      t.json :args
      t.integer :schedulable_id
      t.string :schedulable_type
      t.timestamps
    end
  end
end
