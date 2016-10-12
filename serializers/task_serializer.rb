class TaskSerializer < BaseSerializer
  attributes :id, :title, :image

  def id
    object.id.to_s
  end

  def title
    object.title
  end

  def image
    object.image.url
  end

end
