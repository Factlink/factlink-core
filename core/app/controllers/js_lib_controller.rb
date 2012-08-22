class JsLibController < ApplicationController

  before_filter :check_signed_in, only: [:redir]

  def show_template
    respond_to do |format|
      format.html do
        begin
          render "templates/" + params[:name], :layout => "templates", :content_type => "text/javascript"
        rescue ActionView::MissingTemplate
          raise_404
        end
      end
    end
  end

  def redir
    redirect_to redir_url + params[:path]
  end

  def redir_url
    jslib_url_for(current_user.username).to_s
  end

  private
  def check_signed_in
    unless user_signed_in?
      render text: '/* error: not logged in*/', status: :forbidden
      return
    end
  end
end
