class Secret < ActiveRecord::Base
  has_one :recipient

  accepts_nested_attributes_for :recipient

  attr_accessor :body, :encryption_key

  validates :body, presence: true

  delegate :password, to: :encryptor

  after_initialize do
    build_recipient unless recipient
  end

  after_validation :encrypt_body

  def encryptor
    @encryptor ||= Encryptor.new
  end

private

  def encrypt_body
    encryptor.message = body
    self.encrypted_body = encryptor.encrypt
  rescue EncryptionError
    errors.add :body, I18n.t("errors.messages.encryption")
  end
end
