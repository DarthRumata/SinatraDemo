require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/json'
require 'mongoid'
require 'dotenv'
require 'sinatra-initializers'
require 'carrierwave/mongoid'
require 'active_model_serializers'

require './uploaders/image_uploader'
require './models/task'
require './serializers/base_serializer'
require './serializers/task_serializer'

Dotenv.load '.env'

class TaskModule < Sinatra::Base

  helpers Sinatra::Param
  register Sinatra::Initializers

  configure do
    enable :run
    set :raise_sinatra_param_exceptions, true
    set show_exceptions: false
    set public_folder: 'uploads'
  end

  before do
    content_type 'application/json'
  end

  get '/' do
    task = Task.find params['id']
    json(
        {task:
             {
                 id: task.id.to_s,
                 title: task.title
             }
        }
    )
  end

  post '/' do
    param :id, String, required: true
    param :title, String, required: true
    param :image, String, required: true

    id = params['id']
    title = params['title']
    image = params['image']
    task = Task.create(id: id, title: title)
    task.remote_image_url = image

    task.save!

    json task
  end

  delete '/' do
    param :id, String, required: true

    id = params['id']
    Task.find(id: id).delete
    status 204
  end

  error Sinatra::Param::InvalidParameterError do
    status 422
    {error: "#{env['sinatra.error'].param} is invalid"}.to_s
  end

  error Mongoid::Errors::DocumentNotFound do
    status 404
    {error: 'Not found'}.to_s
  end

end

