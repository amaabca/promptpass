describe "recipient secret form" do
  include Rails.application.routes.url_helpers

  let(:decryption_error) { I18n.t "errors.messages.decryption" }
  let(:valid_password) { "waffles" }
  let(:invalid_password) { "pancakes" }
  let(:secret) { Secret.last }
  let(:recipient_secret_url) { new_recipient_secrets_url(token) }
  let(:decrypt_button) {  I18n.t "forms.secrets.decrypt_button" }
  let(:decrypt_error) { I18n.t "errors.messages.decryption", decryption_count: 1 }

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

        context "has been filled out with an invalid value 5 times" do
          it "shows that the message has been dsetroyed" do
            5.times do
              fill_in "secret_password", with: invalid_password
              click_button decrypt_button
            end

            within("div.secret_password") do
              expect(page).to have_content I18n.t("errors.messages.decryption_destroy")
            end
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
      end

      it "does show us a success message" do
        click_button decrypt_button
        expect(page).to have_content I18n.t("forms.pages.decrypted")
      end

      context "destroy after view" do
        before(:each) do
          click_button decrypt_button
        end

        it "destroys the secret record" do
          expect(Secret.all).to be_empty
        end

        it "users revisit the page" do
          visit recipient_secret_url
          expect(page.driver.response.status).to eq 404
        end
      end

      context "there is a sender" do
        it "sends a receipt email" do
          expect(SecretMailer).to receive(:secret_received).and_call_original
          click_button decrypt_button
        end
      end

      context "there is no sender" do
        before(:each) do
          secret.sender.destroy
        end

        it "does not send a receipt email" do
          expect(SecretMailer).to_not receive(:secret_received).and_call_original
          click_button decrypt_button
        end
      end
    end
  end
end
