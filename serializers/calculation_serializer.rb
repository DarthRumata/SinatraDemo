class CalculationSerializer < BaseSerializer
  attributes :id, :result, :virtual

  def id
    object.id.to_s
  end

  def result
    object.result * object.result
  end

  def virtual
    'virtual'
  end
end
