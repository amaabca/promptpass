class SecretsController < ApplicationController
  expose(:secret, attributes: :secret_params)

  def create
    if secret.save
      render :create
    else
      render :new
    end
  end

private

  def secret_params
    params.require(:secret).permit(:body, recipient_attributes: [:email, :phone_number])
  end
end
