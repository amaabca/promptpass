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
      end

      it "does does not return an error" do
        subject.save
        expect(subject.errors).to be_blank
      end

      it "is set" do
        subject.save
        expect(subject.encrypted_body).to eq encrypted_waffles
      end

      it "has an associated encryption_salt" do
        subject.save
        expect(subject.encryption_salt).to eq subject.encryptor.salt
      end

      it "calls the notify recipient" do
        expect(subject).to receive(:notify_recipient).once
        subject.save
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

  describe "#decrypt" do
    let(:valid_password) { "waffles" }
    let(:invalid_password) { "pancakes" }
    let(:secret) { Secret.last }
    let(:decrypt_error) { I18n.t "errors.messages.decryption", decryption_count: 1 }

    before(:each) do
      stub_const("Twilio::REST::Client", FakeSms)
      allow_any_instance_of(Encryptor).to receive(:password).and_return valid_password
      FactoryGirl.create :secret
      allow_any_instance_of(Encryptor).to receive(:password).and_call_original
    end

    context "invalid password" do
      before(:each) do
        secret.password = invalid_password
      end

      it "returns false" do
        expect(secret.decrypt).to eq false
      end

      it "adds an error" do
        secret.decrypt
        expect(secret.errors[:password]).to include decrypt_error
      end

      it "does not decrypt the message" do
        secret.decrypt
        expect(secret.body).to be_blank
      end

      it "destroys the message" do
        5.times { secret.decrypt }
        expect(secret.errors[:password]).to include I18n.t("errors.messages.decryption_destroy")
        expect(Secret.find_by id: secret.id).to be_nil
      end
    end

    context "valid password" do
      before(:each) do
        secret.password = valid_password
      end

      it "returns true" do
        expect(secret.decrypt).to eq true
      end

      it "does not add an error" do
        secret.decrypt
        expect(secret.errors[:password]).to_not include I18n.t("errors.messages.decryption")
      end

      it "decrypts the message" do
        secret.decrypt
        expect(secret.body).to eq secret.body
      end
    end
  end
end
