class JsLibController < ApplicationController

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
    unless user_signed_in?
      render text: '/* error: not logged in*/', status: :forbidden
      return
    end

    redirect_to redir_url + params[:path]

  end

  def redir_url
    "http://example.org/"
  end
end
