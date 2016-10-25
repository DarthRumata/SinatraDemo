class Task
  include Mongoid::Document

  field :id, type: String
  field :title, type: String

  mount_uploader :image, ImageUploader

end



