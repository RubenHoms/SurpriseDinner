CmSms.configure do |config|
  config.api_key = Rails.application.secrets.cm_sms_api_key or raise 'CM SMS API key not found in secrets file.' unless Rails.env.test?
  config.from    = Rails.application.secrets.cm_sms_send_from or raise 'CM SMS from field not found in secrets file.' unless Rails.env.test?
  # config.to      = # If you want to set a default to (receiver), do it here.
  # config.body    = # If you want to set a default body (message), do it here.
end