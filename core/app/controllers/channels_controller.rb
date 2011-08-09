class ChannelsController < ApplicationController
  
  def index
    
    @user = User.first(:conditions => { :username => params[:username]})
    
    puts "\n*\n*\n*TEH INDEX0RSSS!!\n*\n*\n*"
  end
  
end
