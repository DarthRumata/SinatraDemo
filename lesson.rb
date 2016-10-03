require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/json'
require 'mongoid'
require 'dotenv'
require 'sinatra-initializers'
require 'carrierwave/mongoid'
require 'active_model_serializers'

require './uploaders/image_uploader'
require './models/calculation'
require './serializers/base_serializer'
require './serializers/calculation_serializer'

Dotenv.load

class Lesson < Sinatra::Application
  register Sinatra::Initializers
  configure do
    set :raise_sinatra_param_exceptions, true
    set show_exceptions: false
  end

  before do
    content_type 'application/json'
  end

  get '/last_calculation' do
    calculation = Calculation.find params['id']
    json({ calculation:
      { id: calculation.id.to_s,
        result: calculation.result
      }
    })
  end

  post '/calculations' do
    param :param1,    Float,  required: true
    param :param2,    Float,  required: true
#    param :image,     String, required: true
    param :operation, String, in: ['plus', 'minus']

    result = params['param1'] + params['param2']

    calculation_params = params.merge({ 'result' => result })
    calculation = Calculation.new calculation_params
#    calculation.remote_image_url = params['image']

    calculation.save!

    json calculation
  end

  error Sinatra::Param::InvalidParameterError do
    status 422
    { error: "#{env['sinatra.error'].param} is invalid" }.to_s
  end

  error Mongoid::Errors::DocumentNotFound do
    status 404
    { error: "Not found" }.to_s
  end
end
