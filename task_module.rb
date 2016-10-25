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
require './workers/image_worker'

Dotenv.load '.env'

class TaskModule < Sinatra::Base

  helpers Sinatra::Param
  register Sinatra::Initializers

  configure do
    enable :run
    set :raise_sinatra_param_exceptions, true
    set show_exceptions: false
  end

  before do
    content_type 'application/json'
  end

  get '/:id' do
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

  get '/' do
    all_tasks = []
    Task.all.each do |task|
      all_tasks.append(task)
    end

    json all_tasks
  end

  post '/' do
    param :id, String, required: true
    param :title, String, required: true
    param :image, String, required: true, blank: false

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
    status 200
  end

  post '/process/:id' do
    Workers::ImageWorker.perform_async(params['id'])
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


