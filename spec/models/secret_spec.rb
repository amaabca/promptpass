describe Secret do
  before(:each) do
    subject.recipient = nil
  end

  describe "#body" do
    it "is a required field" do
      subject.body = nil
      subject.valid?
      expect(subject.errors[:body]).to include I18n.t "errors.messages.blank"
    end
  end

  describe "#encrypted_body" do
    before(:each) do
      subject.body = "Waffles are just plain fantastic. Try them!"
    end

    context "successfully encrypts" do
      before(:each) do
        subject.save
      end

      it "does does not return an error" do
        expect(subject.errors).to be_blank
      end

      it "is set" do
        expect(subject.encrypted_body).to be_present
      end
    end

    context "fails to encrypt" do
      before(:each) do
        allow_any_instance_of(Encryptor).to receive(:encrypt).and_raise EncryptionError
        subject.save
      end

      it "returns an error" do
        expect(subject.errors[:body]).to include I18n.t("errors.messages.encryption")
      end

      it "is not set" do
        expect(subject.encrypted_body).to be_blank
      end
    end
  end
end
