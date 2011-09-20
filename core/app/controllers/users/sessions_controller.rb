class Users::SessionsController < Devise::SessionsController

  layout "client"

  def new
    
    # Set return path if available
    # params[:return_path] is used in the SessionController to
    # create the correct return path.
    session[:"user.return_to"] = if params[:return_path]
      then params[:return_path]
      else nil
      end
    
    
    # Toggle the layout
    unless params[:layout].nil?
      # Default login
      
      @users = User.all
      
      render "users/sessions/new", :layout => "frontend"
      return false
    else
      # Client login
      render "user_sessions/new"
      return false
    end
    
    super
  end
  
  def create
    
    # Check if a fact should be added
    if user_signed_in?
      # If the fact to create is set, the user was not logged in before but did\
      # want to add a fact.
      #
      # User is logged in now, so create the fact and redirect to the correct page.
      if session[:fact_to_create]
        fact_hash     = session[:fact_to_create]

        url           = fact_hash['url']
        displaystring = fact_hash['fact']
        title         = fact_hash['title']

        # Clear fact_to_create
        session[:fact_to_create] = nil

        site = Site.find_or_create_by(:url => url)

        @fact = Fact.new(
          :created_by => current_user.graph_user,
          :title => title,
          :displaystring => displaystring,
          :site => site
        )
        @fact.save

        # Required for the Ohm Model
        site.facts << @fact
        

        redirect_to :controller => "/facts", :action => "show", :id => @fact.id
        return false
      end
    end
    
    # Create the session
    super
  end
  
  def destroy
    super
  end
  
end