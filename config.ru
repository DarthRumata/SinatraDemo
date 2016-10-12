require './task_module'
require './web_module'
require 'rack/contrib'

use Rack::PostBodyContentTypeParser

run Rack::URLMap.new('/' => WebModule, '/tasks' => TaskModule)
