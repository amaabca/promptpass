class ActionDispatch::Flash::FlashHashDecorator < Draper::Decorator
  delegate_all

  def confirmation
    return unless notice
    h.render partial: "shared/notice", locals: { notice: notice }
  end
end
