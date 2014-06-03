class BlogController < ApplicationController

  layout 'static_blog_pages'

  skip_before_filter :set_x_frame_options_header # For http://janpaulposma.nl/#factlink-lessons iframe (and others)

  def index
    render layout: 'static_pages'
  end
end
