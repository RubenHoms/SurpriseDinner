namespace :cache do
  desc "Clears Rails cache"
  task :clear => :environment do
    Rails.cache.clear
  end
end

# Hook into existing assets:precompile task, which is invoked on deploy
Rake::Task['assets:precompile'].enhance do
  Rake::Task['cache:clear'].invoke
end