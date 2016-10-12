class Task
  include Mongoid::Document

  field :id, type: String
  field :title, type: String

  mount_uploader :image, ImageUploader

  def to_json
    {
        'id' => :id,
        'title' => :title,
        'image' => :image
    }
  end

end



