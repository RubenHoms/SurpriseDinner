# Setup redis from config based on env
redis_config = YAML.load_file(Rails.root.to_s + '/config/redis.yml')
redis_config.merge! redis_config.fetch(Rails.env, {})
redis_config.symbolize_keys!

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/12", network_timeout: 5 }
end
Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/12", network_timeout: 5 }
end