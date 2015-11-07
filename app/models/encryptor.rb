class Encryptor
  include ActiveModel::Model

  attr_accessor :password, :message

  validates :password, :message, presence: true

  def initialize(args = {})
    args = defaults.merge args
    super
  end

  def encrypt
    raise EncryptionError.new(errors.to_s) unless valid?
    encryptor.encrypt_and_sign message
  end

  def decrypt
    raise EncryptionError.new(errors.to_s) unless valid?
    encryptor.decrypt_and_verify message
  end

private

  def encryptor
    ActiveSupport::MessageEncryptor.new(key)
  end

  def key
    ActiveSupport::KeyGenerator.new(password.to_s).generate_key(salt)
  end

  def salt
    Rails.application.secrets.secret_key_base
  end

  def defaults
    { password: rand(10000...99999) }
  end
end
