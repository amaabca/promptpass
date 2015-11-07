RSpec.describe SecretMailer, type: :mailer do
  describe "#new_secret_email" do
    let(:mail) { SecretMailer.new_secret_email }

    context "email headers" do
      xit "render the headers" do
        expect(mail.subject).to eq I18n.t("mailer.new_secret_email.subject")
        expect(mail.to).to eq ["#{secret.recipient.email}"]
        expect(mail.from).to eq ["[secrectkeeper@promptpass.ca]"]
      end
    end

    context "email body" do
      xit "render the secrect url" do
      end

      xit "render the secrect time span" do
      end
    end
  end
end
