describe Sender do
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
end
