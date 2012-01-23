class FeedbackController < ApplicationController
  def new
  end

  def create
    issue = {
      reporter: {user: current_user.andand.username, email: params[:email]},
      subject: params[:subject],
      content: params[:content]
    }
    begin
      issue = GithubIssue.new.report(issue)
      params = {}
      render :json =>  { msg: "Thank you for your feedback. We have registered your comments under the number #{issue[:number]}".html_safe }
    rescue
      render :json => { msg: "We're sorry, something went wrong with saving your feedback, you can still reach us at feedback@factlink.com".html_safe }, :status => 500
    end
  end
end
