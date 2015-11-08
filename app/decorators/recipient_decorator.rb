class RecipientDecorator < Draper::Decorator
  delegate_all

  def phone_number
    h.number_to_phone(object.phone_number)
  end
end
