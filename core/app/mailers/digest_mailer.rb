class DigestMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "Factlink <support@factlink.com>"

  def discussion_of_the_week_mass_mail(fact_id)
    fact = Fact[fact_id]
    User.receives_digest.each do |user|
      mail_discussion_of_the_week_to_user(user, fact)
    end
  end

  def discussion_of_the_week(user, fact)
    @fact = fact
    @user = user

    mail to: @user.email, subject: 'Discussion of the Week'
  end

end
