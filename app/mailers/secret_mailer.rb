class SecretMailer < ApplicationMailer
  include SendGrid

  def secret_created(args = {})
    sendgrid_disable :opentrack, :clicktrack, :ganalytics
    @secret = args.fetch(:secret, nil).try(:decorate)
    mail(to: @secret.recipient.email, subject: I18n.t("mailer.secret_created.subject"))
  end

  def secret_received(args = {})
    sendgrid_disable :opentrack, :clicktrack, :ganalytics
    @secret = args.fetch(:secret, nil).try(:decorate)
    mail(to: @secret.sender.email, subject: I18n.t("mailer.secret_received.subject"))
  end
end
