class JsLibController < ApplicationController
  def create
    render_template 'create'
  end

  def indicator
    render_template 'indicator'
  end

  def redir
    redirect_to jslib_url + params[:path]
  end

  private

  def render_template name
    render "templates/#{name}",
      layout: "templates",
      content_type: "text/javascript"
  end

end
