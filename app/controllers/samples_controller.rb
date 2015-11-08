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
    "Some cool body information"
  end
end
