require 'sinatra/base'

class UploadsModule < Sinatra::Base

  configure do
    set public_folder: 'uploads'
    set :static_cache_control, [:no_cache]
  end

end