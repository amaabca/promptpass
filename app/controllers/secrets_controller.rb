class SecretsController < ApplicationController
  expose(:secret, attributes: :secret_params)

  before_action :prep_sender, only: :new

  def create
    if secret.save
      redirect_to new_secret_path, notice: I18n.t("notifications.secrets.sent") and return
    else
      prep_sender
      render :new
    end
  end

private

  def prep_sender
    secret.build_sender unless secret.sender
  end

  def secret_params
    params.require(:secret).permit(:body, sender_attributes: [:email], recipient_attributes: [:email, :phone_number])
  end
end
