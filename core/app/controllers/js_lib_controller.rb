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
    redirect_to jslib_url + params[:path]
  end
end
