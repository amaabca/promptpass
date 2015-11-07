#Freebie stub from https://robots.thoughtbot.com/testing-sms-interactions
class FakeSms
  Message = Struct.new(:from, :to, :body)

  cattr_accessor :messages
  self.messages = []

  def initialize(*args)
  end

  def messages
    self
  end

  def create(from:, to:, body:)
    self.class.messages << Message.new(from: from, to: to, body: body)
  end
end