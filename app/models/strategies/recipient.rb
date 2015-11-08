class Strategies::Recipient < DecentExposure::StrongParametersStrategy
  def resource
    ::Recipient.find_by(token: id).tap do |recipient|
      recipient.attributes = attributes if assign_attributes?
    end
  end
end
