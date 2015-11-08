describe Secret do
  let(:recipient) { FactoryGirl.create(:recipient) }

  before(:each) do
    subject.recipient = recipient
  end

  describe "#body" do
    it "is a required field" do
      subject.body = nil
      subject.valid?
      expect(subject.errors[:body]).to include I18n.t "errors.messages.blank"
    end
  end

  describe "#encrypted_body" do
    let(:encrypted_waffles) { "WERFLERS ER JERST PLERN FERNTERSTERC. TRER THERM!"}

    before(:each) do
      subject.body = "Waffles are just plain fantastic. Try them!"
      allow(subject.encryptor).to receive(:encrypt).and_return encrypted_waffles
    end

    context "successfully encrypts" do
      before(:each) do
        stub_const("Twilio::REST::Client", FakeSms)
        subject.save
      end

      it "does does not return an error" do
        expect(subject.errors).to be_blank
      end

      it "is set" do
        expect(subject.encrypted_body).to eq encrypted_waffles
      end

      it "has an associated encryption_salt" do
        expect(subject.encryption_salt).to eq subject.encryptor.salt
      end

      xit "calls the notify recipient" do
        subject.should_receive(:notify_recipient).once
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

      it "has no associated encryption_salt" do
        expect(subject.encryption_salt).to be_blank
      end
    end
  end
end
