class SmsMessage
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :recipient_number, format: { with: /\A\d+\z/ }, presence: true, length: { is: 10 }

  attr_accessor :prompt_pass_number, :recipient_number, :secret_code, :twilio_sid, :twilio_token

  def initialize(args = {})
    self.prompt_pass_number = '+15873175563'
    self.twilio_sid = Rails.configuration.twilio_sid
    self.twilio_token = Rails.configuration.twilio_token
    self.recipient_number = args.fetch(:recipient_number)

    raise "Validation error: #{errors.full_messages.join(",")}" unless valid?
  end

  def send_message
    client = Twilio::REST::Client.new twilio_sid, twilio_token
    client.messages.create(
      from: prompt_pass_number,
      to: "+1#{recipient_number}",
      body: "Promptpass secret code: #{secret_code}"
    )
  end

  def secret_code
    @secret_code ||= rand(10000...99999)
  end
end
