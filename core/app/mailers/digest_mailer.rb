class DigestMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "Factlink <support@factlink.com>"

  def discussion_of_the_week(user, fact, url)
    @user = user
    @fact = fact
    @url  = url

    mail to: @user.email, subject: 'Discussion of the Week'
  end

end
