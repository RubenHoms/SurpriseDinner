# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Load custom tasks from `lib/capistrano/tasks`
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

# Custom includes
require 'capistrano/rvm'
require 'capistrano/rails'
require 'capistrano/puma'
require 'capistrano/sidekiq'