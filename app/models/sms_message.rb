class SmsMessage
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :recipient_number, numericality: { only_integer: true }, presence: true

  attr_accessor :prompt_pass_number, :recipient_number, :secret_code

  def initialize(args = {})
    self.prompt_pass_number = '+15873175563'
    self.recipient_number = args.fetch(:recipient_number)

    raise "Validation error: #{errors.full_messages.join(",")}" unless valid?
  end

  def send_message
    client = Twilio::REST::Client.new
    client.messages.create(
      from: prompt_pass_number,
      to: "+1#{recipient_number}",
      body: "Promptpass secret code: #{secret_code}"
    )
  end

  private

  def secret_code
    @secret_code ||= rand(10000...99999)
  end
end