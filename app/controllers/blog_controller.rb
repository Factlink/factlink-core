class BlogController < ApplicationController

  layout 'static_blog_pages'

  def index
    render layout: 'static_pages'
  end
end
