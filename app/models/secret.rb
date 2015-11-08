class Secret < ActiveRecord::Base
  has_one :recipient

  accepts_nested_attributes_for :recipient

  attr_accessor :body, :encryption_key, :password, :encryptor

  validates :body, presence: true

  after_initialize do
    build_recipient unless recipient
  end

  after_validation :encrypt_body

  after_save :notify_recipient

  def new_secret_email
    @new_secret_email ||= SecretMailer.new_secret_email(secret: self)
  end

  def decrypt
    decrypt_body
    errors[:password].blank?
  end

  def encryptor
    @encryptor ||= Encryptor.new
  end

private

  def decrypt_body
    encryptor.tap { |e| e.password, e.salt, e.message = password, encryption_salt, encrypted_body }
    self.body = encryptor.decrypt
  rescue ActiveSupport::MessageVerifier::InvalidSignature, EncryptionError
    errors.add :password, I18n.t("errors.messages.decryption")
  end

  def encrypt_body
    encryptor.message = body
    self.encrypted_body = encryptor.encrypt
    self.encryption_salt = encryptor.salt
  rescue EncryptionError
    errors.add :body, I18n.t("errors.messages.encryption")
  end

  def notify_recipient
    send_email
    send_sms
  end

  def send_email
    new_secret_email.deliver_now
  end

  def send_sms
    SmsMessage.new(recipient_number: recipient.phone_number, secret_code: encryptor.password).send_message
  end
end
