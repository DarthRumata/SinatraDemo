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
require './helpers/base64_decoder'

Dotenv.load '.env'

class TaskModule < Sinatra::Base

  helpers Sinatra::Param, Decoder
  register Sinatra::Initializers

  configure do
    set :raise_sinatra_param_exceptions, true
    set show_exceptions: false
  end

  before do
    content_type 'application/json'
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
    param :type, String, required: true, in: ['base64', 'url']

    one_of :imageUrl, :imageContent

    id = params['id']
    title = params['title']
    type = params['type']

    task = Task.create(id: id, title: title)
    if type == 'base64'
      encoded_image = request.body.read
      decoded_image = Base64Decoder.decode(encoded_image)
      file = File.new('new.jpg', 'wb')
      file.write(decoded_image)
      task.image = file
    else
      url = request.body.read
      task.remote_image_url = url
    end

    task.save!



    json task
  end

  delete '/' do
    param :id, String, required: true

    id = params['id']
    Task.find(id: id).delete
    status 204
  end

  post '/process/:id' do
    param :id, String, required: true

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


