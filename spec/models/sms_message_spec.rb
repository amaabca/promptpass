describe SmsMessage do
  describe "validations" do
    let(:token_id) { "5hg83" }

    before(:each) do
      stub_const("Twilio::REST::Client", FakeSms)
    end

    context "validation successful" do
      let(:message) { SmsMessage.new({recipient_number:'7809072962', secret_code: '10293', token_id: token_id}) }

      it "sends a message with the secret_code" do
        expect(message.send_message.last.from[:body]).to include "#{I18n.t("sms.text")} #{message.secret_code}"
      end

      it "sends a message with the token_id" do
        expect(message.send_message.last.from[:body]).to include token_id
      end
    end

    context "validation unsuccessful" do
      it "should fail" do
        expect { SmsMessage.new({recipient_number:'+17809072962'}).send_message }.to raise_error RuntimeError
        expect { SmsMessage.new({}).send_message }.to raise_error RuntimeError
        expect { SmsMessage.new({recipient_number:'9072962'}).send_message }.to raise_error RuntimeError
      end
    end
  end
end
