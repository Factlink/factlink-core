class Users::SessionsController < Devise::SessionsController

  layout "client"

  def new
    
    # Set return path if available
    # params[:return_path] is used in the SessionController to
    # create the correct return path.
    session[:"user.return_to"] = params[:return_path]
    
    
    # Toggle the layout
    unless params[:layout].nil?
      # Default login
      
      # TODO: WTF
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

        @fact = create_fact(url, displaystring, title)

        # Clear fact_to_create
        session[:fact_to_create] = nil

        redirect_to :controller => "/facts", :action => "edit", :id => @fact.id
        return false
      end
    end
    
    # Create the session
    super
  end
  
  def destroy
    super
  end

  private
  def create_fact(url, displaystring, title) # private
    @site = Site.find(:url => url).first || Site.create(:url => url)
    @fact = Fact.create(
      :created_by => current_user.graph_user,
      :site => @site
    )
    @fact.data.displaystring = displaystring    
    @fact.data.title = title
    @fact.data.save
    @fact
  end  
end
