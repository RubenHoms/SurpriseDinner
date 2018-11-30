require 'mandrill'

class ApplicationMailer < ActionMailer::Base
  default from: 'Surprise Dinner <hallo@surprisedinner.nl>'

  private

  def mandrill_template(template_name, merge_vars)
    mandrill = Mandrill::API.new(ENV["SMTP_PASSWORD"])

    mandrill.templates.render(template_name, [], merge_vars)["html"]
  end
end
