module Recipients
  class SecretsController < ApplicationController
    expose(:recipient, strategy: Strategies::Recipient)
    expose(:secret, strategy: Strategies::Recipients::Secret, attributes: :secret_params)

    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    before_action do
      raise ActiveRecord::RecordNotFound if recipient.blank?
    end

    before_action do
      secret.destroy if secret.expired?
    end

    def create
      if secret.decrypt
        tidy_up
        render :create
      else
        render :new
      end
    end

  private

    def tidy_up
      secret.sender.try(:send_email)
      secret.destroy if secret.destroy?
    end

    def secret_params
      params.require(:secret).permit(:password)
    end
  end
end
