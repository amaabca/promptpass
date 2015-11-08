class Sender < ActiveRecord::Base
  belongs_to :secret

  normalize_attribute :email

  validates :token,
            presence: true

  validates :email,
            presence: true,
            format: { with: /\A[^`@\s]+@([^@`\s\.]+\.)+[^`@\s\.]+\z/, message: I18n.t("errors.messages.email"), allow_nil: true }

  before_validation do
    self.token = SecureRandom.hex 32
  end

  def send_email
    SecretMailer.secret_received(secret: secret).deliver_now
  end
end
