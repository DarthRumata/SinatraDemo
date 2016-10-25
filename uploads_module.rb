require 'sinatra/base'

class UploadsModule < Sinatra::Base

  configure do
    set public_folder: 'uploads'
  end

end