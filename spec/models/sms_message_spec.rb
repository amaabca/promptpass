describe SmsMessage do
  describe "validations" do
    it "should pass" do
      token_id = "5hg83"
      stub_const("Twilio::REST::Client", FakeSms)
      message = SmsMessage.new({recipient_number:'7809072962', secret_code: '10293', token_id: token_id})
      expect(message.send_message.last.from[:body]).to eq "#{I18n.t("sms.text")} #{message.secret_code}, for secret #{token_id}"
    end

    it "should fail" do
      expect { SmsMessage.new({recipient_number:'+17809072962'}).send_message }.to raise_error RuntimeError
      expect { SmsMessage.new({}).send_message }.to raise_error RuntimeError
      expect { SmsMessage.new({recipient_number:'9072962'}).send_message }.to raise_error RuntimeError
    end
  end
end
