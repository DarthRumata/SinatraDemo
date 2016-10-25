require 'sidekiq/worker'
require 'mini_magick'

require './models/task'

module Workers
  class ImageWorker
    include Sidekiq::Worker
    include MiniMagick

    def perform(id)
      task = Task.find(id: id)
      logger.info "Job is done: #{task.id}"
      unless task.image.file.nil?
        image = MiniMagick::Image.new(task.image.current_path)
        image.flip
      end
    end

  end
end