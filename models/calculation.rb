class Calculation # => calculations
  include Mongoid::Document

  field :param1,       type: Float
  field :param2,       type: Float
  field :operation,    type: String
  field :result,       type: Float

  #mount_uploader :image, ImageUploader
end



