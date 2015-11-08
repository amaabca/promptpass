class SecretMailer < ApplicationMailer

  def new_secret_email(args = {})
    @secret = args.fetch(:secret, nil).try(:decorate)
    mail(to: @secret.recipient.email, subject: I18n.t("mailer.new_secret_email.subject"))
  end
end