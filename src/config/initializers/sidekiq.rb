sidekiq_config = { url: ENV['JOB_WORKER_URL'] }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

# tell redis to STFU about the exists? boolean change
# see: https://github.com/mperham/sidekiq/issues/4591
Redis.exists_returns_integer = false
