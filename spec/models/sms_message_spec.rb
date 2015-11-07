describe SmsMessage do
  describe "validations" do
    it "should pass" do
      stub_const("Twilio::REST::Client", FakeSms)
      message = SmsMessage.new({recipient_number:'7809072962'})
      expect(message.send_message.first.from[:body]).to eq "Promptpass secret code: #{message.secret_code}"
    end
    
    it "should fail" do
      expect { SmsMessage.new({recipient_number:'+17809072962'}).send_message }.to raise_error RuntimeError
      expect { SmsMessage.new({}).send_message }.to raise_error KeyError
      expect { SmsMessage.new({recipient_number:'9072962'}).send_message }.to raise_error RuntimeError
    end
  end
end
