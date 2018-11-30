module FlashMessageHelper

  BOOTSTRAP_FLASH_MSG = {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
  }

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{BOOTSTRAP_FLASH_MSG[msg_type.to_sym]} fade in") do
        concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end
end