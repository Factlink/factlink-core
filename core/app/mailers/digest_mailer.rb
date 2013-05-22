class DigestMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "Factlink <support@factlink.com>"

  def discussion_of_the_week(user_id, fact_id, url)
    @user = User.find(user_id)
    @fact = Fact[fact_id]
    @url  = url

    @hide_header_image = true

    mail to: @user.email, subject: 'Discussion of the Week'
  end

end
