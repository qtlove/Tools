require 'rubygems'
require 'action_mailer'
require 'smtp_tls'

class SimpleMailer < ActionMailer::Base
  def simple_message(recipient, subject, body)
    recipients recipient
    subject subject
    body body
  end
end

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :user_name=> "campusbg@gmail.com",
  :password => "campusbg2009"
}

SimpleMailer.deliver_simple_message("qixiang@51hejia.com", "测试邮件标题", "测试邮件内容")
