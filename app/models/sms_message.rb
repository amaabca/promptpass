class SmsMessage
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :recipient_number, format: { with: /\A\d+\z/ }, presence: true, length: { is: 10 }

  attr_accessor :prompt_pass_number, :recipient_number, :secret_code, :token_id, :twilio_sid, :twilio_token

  def initialize(args = {})
    args = args.merge defaults
    super
    raise "Validation error: #{errors.full_messages.join(",")}" unless valid?
  end

  def send_message
    client = Twilio::REST::Client.new twilio_sid, twilio_token
    client.messages.create(
      from: prompt_pass_number,
      to: "+1#{recipient_number}",
      body: "#{I18n.t("sms.text")} #{secret_code}, for secret #{token_id}"
    )
  end

private

  def defaults
    {
      prompt_pass_number: '+15873175563',
      twilio_sid: Rails.configuration.twilio_sid,
      twilio_token: Rails.configuration.twilio_token
    }
  end
end
