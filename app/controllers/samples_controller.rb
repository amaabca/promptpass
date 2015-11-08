class SamplesController < ApplicationController
  expose(:sample, model: :secret, attributes: :sample_params)

  def create
    if sample.save
      redirect_to root_path, notice: I18n.t("notifications.secrets.sent") and return
    else
      render :new
    end
  end

private

  def sample_params
    params.require(:sample).permit(recipient_attributes: [:email, :phone_number]).merge(body: body)
  end

  def body
    "How does Prompt Pass work?\r\n1. A secret is sent to Prompt Pass over a secure communication channel.\r\n2. Prompt Pass encrypts the secret with a combination of a salt and access code.\r\n3. An email and SMS containing the access code is sent to the recipient.\r\n4. The recipient visits the secret url in the email and enters the access code from their phone.\r\n5. Pass Prompt uses the access code and the salt to decrypt the message and display it to the recipient.\r\n6. The secret message is destroyed after viewing.\r\n\r\nAre my messages secure?\r\n- Secrets are encrypted with 256 bit encryption using the access code.\r\n- Only the person with the access code can decrypt the secret message.\r\n- Prompt Pass is unable to view any of the content within a secret message.\r\n- Brute force protection is applied when accessing the secret message. After 5 invalid - attempts the secret is destroyed.\r\n- We do not have Google Analytics/email click or open tracking. We value your privacy.\r\n- We don't store any of the secret messages or access codes in our logs.\r\n- We're open source so you can review our code to review the security for yourself.\r\n\r\nMore questions/concerns? Visit the about link at the top of the page."
  end
end
