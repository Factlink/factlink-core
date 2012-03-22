class FeedbackController < ApplicationController
  def new
    render layout: "frontend", locals: { dont_render_feedback: true} unless request.xhr?
  end

  def create
    issue = {
      reporter: {user: current_user.andand.username, email: params[:email]},
      subject: params[:subject],
      content: params[:content]
    }

    begin
      issue_gh = GithubIssue.new.report(issue)
      render :json =>  { msg: "Thank you for your feedback \"#{CGI::escapeHTML(issue[:subject])}\"! We will get back to you shortly" }

    rescue
      ExceptionNotifier::Notifier.exception_notification(request.env, $!).deliver
      render :json => { msg: "We're sorry, something went wrong with saving your feedback, you can still reach us at feedback@factlink.com" }, :status => 500
    end
  end
end
