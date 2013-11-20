class LogMailer < ActionMailer::Base
  default from: "machine@b2bsoft.by"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.log_mailer.update_report.subject
  #
  def update_report(site)
    @logs = Site.find(site).logs
    @site = site

    mail to: "support@b2bsoft.by", subject: site.name + ' ' + Time.now.to_formatted_s(:short)
  end
end
