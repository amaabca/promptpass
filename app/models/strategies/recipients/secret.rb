class Strategies::Recipients::Secret < DecentExposure::StrongParametersStrategy
  delegate :recipient, to: :controller

  def resource
    recipient.secret.tap do |secret|
      secret.attributes = attributes if assign_attributes?
    end
  end
end
