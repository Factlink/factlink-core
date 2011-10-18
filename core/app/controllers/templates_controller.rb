class TemplatesController < ApplicationController
  layout "templates" 

  def get
    respond_to do |format| 
      format.html {render "templates/" + params[:name], :content_type => "text/javascript"}
    end
  end
end
