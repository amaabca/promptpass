describe "recipient secret form" do
  include Rails.application.routes.url_helpers

  let(:decryption_error) { I18n.t "errors.messages.decryption" }
  let(:valid_password) { "waffles" }
  let(:invalid_password) { "pancakes" }
  let(:secret) { Secret.last }
  let(:recipient_secret_url) { new_recipient_secrets_url(token) }
  let(:decrypt_button) {  I18n.t "forms.secrets.decrypt_button" }
  let(:decrypt_error) { I18n.t "errors.messages.decryption" }

  before(:each) do
    stub_const("Twilio::REST::Client", FakeSms)
    allow_any_instance_of(Encryptor).to receive(:password).and_return valid_password
    FactoryGirl.create :secret
    allow_any_instance_of(Encryptor).to receive(:password).and_call_original
    visit recipient_secret_url
  end

  context "invalid recipient token" do
    let(:token) { "waffles" }

    it "returns a 404 response" do
      expect(page.driver.response.status).to eq 404
    end
  end

  context "valid recipient token" do
    let(:token) { secret.recipient.token }

    context "there are errors on the form" do
      describe "#password" do
        context "has not been filled out" do
          before(:each) do
            fill_in "secret_password", with: ""
            click_button decrypt_button
          end

          it "shows a required field error" do
            within("div.secret_password") do
              expect(page).to have_content decrypt_error
            end
          end

          it "does not show us a success message" do
            expect(page).to_not have_content I18n.t("forms.pages.decrypted")
          end
        end

        context "has been filled out with an invalid value" do
          before(:each) do
            fill_in "secret_password", with: invalid_password
            click_button decrypt_button
          end

          it "shows a required field error" do
            within("div.secret_password") do
              expect(page).to have_content decrypt_error
            end
          end

          it "does not show us a success message" do
            expect(page).to_not have_content I18n.t("forms.pages.decrypted")
          end
        end
      end
    end

    context "token id" do
      it "shows the token id of the recipient" do
        expect(page).to have_content secret.recipient.token_id
      end
    end

    context "there are no errors on the form" do
      before(:each) do
        fill_in "secret_password", with: valid_password
        click_button decrypt_button
      end

      it "does show us a success message" do
        expect(page).to have_content I18n.t("forms.pages.decrypted")
      end

      context "destroy after view" do
        it "destroys the secret record" do
          expect(Secret.all).to be_empty
        end

        it "users revisit the page" do
          visit recipient_secret_url
          expect(page.driver.response.status).to eq 404
        end
      end
    end
  end
end
