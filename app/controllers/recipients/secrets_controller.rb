module Recipients
  class SecretsController < ApplicationController
    expose(:recipient, strategy: Strategies::Recipient)
    expose(:secret, strategy: Strategies::Recipients::Secret, attributes: :secret_params)

    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    before_action do
      raise ActiveRecord::RecordNotFound if recipient.blank?
    end

    def create
      if secret.decrypt
        secret.destroy unless Rails.env.development?
        render :create
      else
        render :new
      end
    end

  private

    def secret_params
      params.require(:secret).permit(:password)
    end
  end
end
