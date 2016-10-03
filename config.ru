require './lesson'
require 'rack/contrib'

use Rack::PostBodyContentTypeParser

run Lesson
