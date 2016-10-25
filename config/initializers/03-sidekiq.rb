require 'sidekiq'

def configure_server
  Sidekiq.configure_server do |config|
    config.redis   = redis_config
  end
end

def configure_client
  Sidekiq.configure_client do |config|
    config.redis   = redis_config
  end
end

def redis_config
  config = {
      host: ENV['REDIS_HOST'],
      port: ENV['REDIS_PORT'].to_i,
      namespace: ENV['REDIS_NAMESPACE']
  }
  unless ENV['REDIS_USERNAME'].nil? || ENV['REDIS_USERNAME'].empty?
    config[:username] = ENV['REDIS_USERNAME']
  end
  unless ENV['REDIS_PASSWORD'].nil? || ENV['REDIS_PASSWORD'].empty?
    config[:password] = ENV['REDIS_PASSWORD']
  end

  config
end

configure_server
configure_client