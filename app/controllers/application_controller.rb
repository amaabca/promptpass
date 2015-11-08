class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  expose(:flash_presenter) { flash.decorate }

  def render_404
    render "shared/not_found", status: :not_found and return
  end
end
