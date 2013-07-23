class JsLibController < ApplicationController
  layout 'templates'

  def create
    render_template 'create'
  end

  def indicator
    render_template 'indicator'
  end

  private

  def render_template name
    render "templates/#{name}", content_type: "text/javascript"
  end
end
