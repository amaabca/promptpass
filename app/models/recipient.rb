class Recipient < ActiveRecord::Base
  belongs_to :secret

  normalize_attribute :phone_number, with: :phone
  normalize_attribute :email

  validates :phone_number,
            presence: true,
            numericality: { allow_nil: true },
            length: { is: 10, allow_nil: true, message: I18n.t("errors.messages.phone_number") }

  validates :email,
            presence: true,
            format: { with: /\A[^`@\s]+@([^@`\s\.]+\.)+[^`@\s\.]+\z/, message: I18n.t("errors.messages.email"), allow_nil: true }
end