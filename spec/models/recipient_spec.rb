describe Recipient do
  describe "#phone_number" do
    it "normalizes so that there are no non-numeric characters" do
      subject.phone_number = "(555) 123-1234"
      expect(subject.phone_number).to eq "5551231234"
    end

    context "must be present" do
      let(:error_message) { I18n.t "errors.messages.blank" }

      context "is not a set of numbers, so becomes nil due to normalization" do
        it "sets an error message" do
          subject.phone_number = "waffles"
          subject.valid?
          expect(subject.errors[:phone_number]).to include error_message
        end
      end

      context "is nil" do
        it "sets an error message" do
          subject.phone_number = nil
          subject.valid?
          expect(subject.errors[:phone_number]).to include error_message
        end
      end
    end

    context "is not 10 digits long" do
      let(:error_message) { I18n.t "errors.messages.phone_number" }

      context "is too short" do
        it "sets an phone number error message" do
          subject.phone_number = "123123"
          subject.valid?
          expect(subject.errors[:phone_number]).to include error_message
        end
      end

      context "is too long" do
        it "sets an phone number error message" do
          subject.phone_number = "123123123123123123"
          subject.valid?
          expect(subject.errors[:phone_number]).to include error_message
        end
      end
    end
  end

  describe "#email" do
    context "must be present" do
      let(:error_message) { I18n.t "errors.messages.blank" }

      it "sets an error message" do
        subject.email = nil
        subject.valid?
        expect(subject.errors[:email]).to include error_message
      end
    end

    context "must be present" do
      let(:error_message) { I18n.t "errors.messages.blank" }

      it "sets an error message" do
        subject.email = nil
        subject.valid?
        expect(subject.errors[:email]).to include error_message
      end
    end

    context "must be present" do
      let(:error_message) { I18n.t "errors.messages.email" }

      it "sets an error message" do
        subject.email = "8675309"
        subject.valid?
        expect(subject.errors[:email]).to include error_message
      end
    end
  end

  describe "#token" do
    context "must be present" do
      let(:error_message) { I18n.t "errors.messages.blank" }

      it "sets an error message" do
        allow(subject).to receive(:token).and_return nil
        subject.valid?
        expect(subject.errors[:token]).to include error_message
      end
    end
  end

  describe "#token_id" do
    context "token is set" do
      it "returns the first 5 chars of the token" do
        subject.valid?
        expect(subject.token_id).to eq subject.token[0..5]
      end
    end

    context "token is not set" do
      it "returns the first 5 chars of the token" do
        expect(subject.token_id).to eq nil
      end
    end
  end

end
