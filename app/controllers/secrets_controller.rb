class SecretsController < ApplicationController
  expose(:secret, attributes: :secret_params)

  def create
    if secret.save
      redirect_to new_secret_path, notice: I18n.t("notifications.secrets.sent") and return
    else
      render :new
    end
  end

private

  def secret_params
    params.require(:secret).permit(:body, recipient_attributes: [:email, :phone_number])
  end
end
