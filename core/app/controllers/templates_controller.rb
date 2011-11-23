class TemplatesController < ApplicationController

  def show
    respond_to do |format| 
      format.html {render "templates/" + params[:name], :layout => "templates", :content_type => "text/javascript"}
    end
  end
end
