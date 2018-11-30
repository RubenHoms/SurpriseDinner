context.instance_eval do
  panel 'Opdrachten' do
    table_for scheduled_jobs do
      column :job_name
      column('Opdracht aanwezig?') { |scheduled_job| scheduled_job.job.present? }
      column :at
      column :args
      column :created_at
      column :updated_at
    end
  end
end