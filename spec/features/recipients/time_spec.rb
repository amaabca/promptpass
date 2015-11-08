describe "recipient secret form" do
  include Rails.application.routes.url_helpers

  let(:decryption_error) { I18n.t "errors.messages.decryption" }
  let(:valid_password) { "waffles" }
  let(:invalid_password) { "pancakes" }
  let(:secret) { Secret.last }
  let(:recipient_secret_url) { new_recipient_secrets_url(recipient.token) }
  let(:decrypt_button) {  I18n.t "forms.secrets.decrypt_button" }
  let(:decrypt_error) { I18n.t "errors.messages.decryption", decryption_count: 1 }
  let(:recipient) { FactoryGirl.create(:recipient) }

  before(:each) do
    stub_const("Twilio::REST::Client", FakeSms)
    allow_any_instance_of(Encryptor).to receive(:password).and_return valid_password
    FactoryGirl.create :secret, expiry: Time.now + 1.hours
    secret.recipient = recipient
    allow_any_instance_of(Encryptor).to receive(:password).and_call_original
  end

  it "destroys secret if current time is greater than expiry" do
    Timecop.freeze(Time.now + 2.hours) do
      visit recipient_secret_url
      fill_in "secret_password", with: valid_password
      click_button decrypt_button
      expect(Secret.all).to be_empty
      expect(page.driver.response.status).to eq 404
    end
  end

  it "does not destroys secret if current time is not greater than expiry" do
    visit recipient_secret_url
    fill_in "secret_password", with: valid_password
    click_button decrypt_button
    expect(Secret.all).to_not be_empty
  end
end
