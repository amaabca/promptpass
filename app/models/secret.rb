class Secret < ActiveRecord::Base
  has_one :recipient

  accepts_nested_attributes_for :recipient

  attr_accessor :body, :encryption_key

  validates :body, presence: true

  delegate :password, :salt, to: :encryptor

  after_initialize do
    build_recipient unless recipient
  end

  after_validation :encrypt_body

  after_save :generate_token
  after_save :notify_recipient

  def new_secret_email
    @new_secret_email ||= SecretMailer.new_secret_email(secret: self)
  end

  def encryptor
    @encryptor ||= Encryptor.new
  end

private

  def encrypt_body
    encryptor.message = body
    self.encrypted_body = encryptor.encrypt
    self.encryption_salt = salt
  rescue EncryptionError
    errors.add :body, I18n.t("errors.messages.encryption")
  end

  def generate_token
    recipient.update_column(:token, "#{SecureRandom.hex(64)}")
  end

  def notify_recipient
    if recipient.token.present? # just to be on the safe side NOTE: find a better way to handle this
      send_email
      send_sms
    end
  end

  def send_email
    new_secret_email.deliver_now
  end

  def send_sms
    SmsMessage.new(recipient_number: recipient.phone_number).send_message
  end
end
