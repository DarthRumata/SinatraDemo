require 'sidekiq/worker'

require './models/task'

module Workers
  class ImageWorker
    include Sidekiq::Worker

    def perform(id)
      task = Task.find(id: id)
      logger.info "Job is done #{task.title}"
      task.image
    end

  end
end