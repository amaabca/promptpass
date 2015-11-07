class SecretDecorator < Draper::Decorator
  delegate_all
  decorates_association :recipient

  def secret_url
    h.recipient_url recipient.token
  end
end
