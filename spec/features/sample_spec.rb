describe "sample form" do
  let(:required_field_error) { I18n.t "errors.messages.blank" }
  let(:email_error) { I18n.t "errors.messages.email" }
  let(:phone_number_error) { I18n.t "errors.messages.phone_number" }
  let(:submit_button) {  I18n.t "forms.samples.submit_button" }

  before(:each) do
    visit root_path
  end

  context "there are errors on the form" do
    describe "#email" do
      context "has not been filled out" do
        before(:each) do
          fill_in "sample_recipient_attributes_email", with: ""
          click_button submit_button
        end

        it "shows a required field error" do
          within("div.sample_recipient_email") do
            expect(page).to have_content required_field_error
          end
        end

        it "does not show us a success message" do
          expect(page).to_not have_content I18n.t("notifications.secrets.sent")
        end
      end

      context "has been filled out with an invalid value" do
        before(:each) do
          fill_in "sample_recipient_attributes_email", with: "waffles"
          click_button submit_button
        end

        it "shows a required field error" do
          within("div.sample_recipient_email") do
            expect(page).to have_content email_error
          end
        end

        it "does not show us a success message" do
          expect(page).to_not have_content I18n.t("notifications.secrets.sent")
        end
      end
    end

    describe "#phone_number" do
      context "has not been filled out" do
        before(:each) do
          fill_in "sample_recipient_attributes_phone_number", with: ""
          click_button submit_button
        end

        it "shows a required field error" do
          within("div.sample_recipient_phone_number") do
            expect(page).to have_content required_field_error
          end
        end

        it "does not show us a success message" do
          expect(page).to_not have_content I18n.t("notifications.secrets.sent")
        end
      end

      context "has been filled out with an invalid value" do
        before(:each) do
          fill_in "sample_recipient_attributes_phone_number", with: "123123"
          click_button submit_button
        end

        it "shows a required field error" do
          within("div.sample_recipient_phone_number") do
            expect(page).to have_content phone_number_error
          end
        end

        it "does not show us a success message" do
          expect(page).to_not have_content I18n.t("notifications.secrets.sent")
        end
      end
    end
  end

  context "there are no errors on the form" do
    before(:each) do
      stub_const("Twilio::REST::Client", FakeSms)
      fill_in "sample_recipient_attributes_email", with: "youlike@secrets.com"
      fill_in "sample_recipient_attributes_phone_number", with: "555-123-1234"
      click_button submit_button
    end

    it "shows us a success message" do
      expect(page).to have_content I18n.t("notifications.secrets.sent")
    end
  end
end
