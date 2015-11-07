RSpec.describe SecretMailer, type: :mailer do
  let(:secret) { FactoryGirl.create(:secret) }

  before(:each) do
    stub_const("Twilio::REST::Client", FakeSms)
  end

  describe "#new_secret_email" do
    let(:mail) { SecretMailer.new_secret_email(secret: secret) }

    context "email headers" do
      it "render the headers" do
        expect(mail.subject).to eq I18n.t("mailer.new_secret_email.subject")
        expect(mail.to).to eq ["#{secret.recipient.email}"]
        expect(mail.from).to eq ["secrectkeeper@promptpass.ca"]
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
end
