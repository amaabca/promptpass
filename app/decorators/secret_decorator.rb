class SecretDecorator < Draper::Decorator
  delegate_all
  decorates_association :recipient

  def secret_url
    h.new_recipient_secrets_url recipient.token
  end
end
