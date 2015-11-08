RSpec.describe SecretMailer, type: :mailer do
  let(:secret) { FactoryGirl.create(:secret) }

  before(:each) do
    stub_const("Twilio::REST::Client", FakeSms)
  end

  describe "#secret_created" do
    let(:mail) { SecretMailer.secret_created(secret: secret) }

    context "email headers" do
      it "render the headers" do
        expect(mail.subject).to eq I18n.t("mailer.secret_created.subject")
        expect(mail.to).to eq ["#{secret.recipient.email}"]
        expect(mail.from).to eq ["secretkeeper@prompt-pass.com"]
      end
    end

    context "email body" do
      it "render the secret url" do
        expect(mail.body.encoded).to match "http://localhost:3000/recipients/#{secret.recipient.token}"
      end

      xit "render the secret time span" do
      end
    end
  end

  describe "#secret_received" do
    let(:mail) { SecretMailer.secret_received(secret: secret) }

    context "email headers" do
      it "render the headers" do
        expect(mail.subject).to eq I18n.t("mailer.secret_received.subject")
        expect(mail.to).to eq ["#{secret.sender.email}"]
        expect(mail.from).to eq ["secretkeeper@prompt-pass.com"]
      end
    end

    context "email body" do
      it "render the secret url" do
        expect(mail.body.encoded).to match "Your secret message was received and read by <strong>#{secret.recipient.email}</strong>"
      end
    end
  end
end
