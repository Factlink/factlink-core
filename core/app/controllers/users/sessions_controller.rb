class Users::SessionsController < Devise::SessionsController
  
  # layout "accounting"
  layout "client"

  def new
        
    unless params[:layout].nil?
      # Default login
      render "users/sessions/new", :layout => "accounting"
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

        site = Site.find_or_create_by(:url => url)
        # Create the Factlink
        @factlink = Factlink.create!(:displaystring => displaystring, 
                                        :created_by => current_user,
                                        :site => site)

        redirect_to(@factlink)
        return false
      end
    end

    super
  end
  
  def destroy
    super
  end
  
end