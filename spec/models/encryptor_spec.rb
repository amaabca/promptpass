describe Encryptor do
  let(:message) { "Waffles are just plain fantastic. Try them!" }

  it "sets a default password" do
    expect(subject.password).to be_present
  end

  describe "#encrypt" do
    before(:each) do
      subject.message = message
    end

    it "requires a message" do
      subject.message = nil
      expect { subject.encrypt }.to raise_error EncryptionError
    end

    it "requires a password" do
      subject.password = nil
      expect { subject.encrypt }.to raise_error EncryptionError
    end

    it "requires a salt" do
      subject.salt = nil
      expect { subject.encrypt }.to raise_error EncryptionError
    end

    it "returns a string" do
      expect(subject.encrypt).to be_present
    end

    it "returns an encrypted message" do
      expect(subject.encrypt).to_not eq message
    end

    it "can decrypt a message with a key" do
      subject.message = subject.encrypt
      expect(subject.decrypt).to eq message
    end
  end
end
