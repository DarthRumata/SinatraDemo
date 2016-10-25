require './task_module'
require './web_module'
require './uploads_module'
require 'rack/contrib'
require 'sidekiq/web'

use Rack::PostBodyContentTypeParser

run Rack::URLMap.new(
    '/' => WebModule,
    '/tasks' => TaskModule,
    '/uploads' => UploadsModule,
    '/work' => Sidekiq::Web
)
