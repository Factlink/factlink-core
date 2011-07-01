class FactlinksController < ApplicationController

  helper_method :sort_column, :sort_direction

  before_filter :store_fact_for_non_signed_in_user, :only => [:create]

  # Change this to :except, in stead of :only. 
  before_filter :authenticate_user!, :only => [:new, 
    :edit, 
    :create, 
    :update,
    :add_source_to_factlink,
    :add_factlink_to_parent,
    :remove_factlink_from_parent,
    :believe,
    :doubt,
    :disbelieve,
    :set_opinion
    ]
  
  layout "client"
  
  # Check if the user is signed in before adding a Factlink.
  # If this is not the case, store the params in a session variable,
  # so the Factlink can be created after logging in.
  def store_fact_for_non_signed_in_user
    unless user_signed_in?
      session[:fact_to_create] = params
    end    
  end

  def factlinks_for_url
    url = params[:url]
    site = Site.first(:conditions => { :url => url })
    
    @factlinks = if site
                 then site.factlinks
                 else []
                 end

    # Render the result with callback, 
    # so JSONP can be used (for Internet Explorer)
    render :json => @factlinks.to_json( :only => [:_id, :displaystring], :methods => :score_dict_as_percentage  ), 
                                        :callback => params[:callback]  
  end

  def show
    @factlink = Factlink.find(params[:id])
    
    # TODO: Generate ajax request for potential sources
    # All sources that are not part of this factlink yet

    # Create copy of ids array
    not_allowed_child_ids = Array.new(@factlink.child_ids)
    not_allowed_child_ids << @factlink.id
    
    not_allowed_parent_ids = Array.new(@factlink.parent_ids)
    not_allowed_parent_ids << @factlink.id
    
    @potential_childs = Factlink.not_in( :_id => not_allowed_child_ids )
    @potential_parents = Factlink.not_in( :_id => not_allowed_parent_ids )
  end
  
  def new
    @factlink = Factlink.new
  end
  
  def edit
    @factlink = Factlink.find(params[:id])
  end
  
  # Prepare for create
  def prepare
    render :template => 'factlinks/prepare', :layout => nil
  end
  
  # Prepare for create
  def intermediate
    # TODO: Sanitize for XSS
    @url = params[:url]
    @passage = params[:passage]
    @fact = params[:fact]
    
    case params[:the_action]
    when "prepare"
      @path = "factlink_prepare_path"
    when "show"
      @path = "factlink_show_path(%x)" % :id
    else
      @path = ""
    end

    render :template => 'factlinks/intermediate', :layout => nil
  end

  def create
    # Creating a Factlink requires a url and fact ( > displaystring )
    # TODO: Refactor 'fact' to 'displaystring' for internal consistency
    
    # Get or create the website on which the Fact is located
    site = Site.find_or_create_by(:url => params[:url])


    # TODO: This can be changed to use only displaystring when the above
    # refactor is done.
    if params[:fact]
      displaystring = params[:fact]
    else
      displaystring = params[:factlink][:displaystring]
    end
    
    # Create the Factlink
    @factlink = Factlink.create!(:displaystring => displaystring, 
                                    :created_by => current_user,
                                    :site => site)

    # Redirect to edit action
    redirect_to :action => "edit", :id => @factlink.id
  end

  
  def add_source_to_factlink
    # Add an existing source to a Factlink
    @factlink = Factlink.find(params[:factlink_id])
    @source   = Factlink.find(params[:source_id])

    @source.set_parent @factlink.id

    @factlink.add_child_as_supporting(@source)
  end
  
  def add_source_as_supporting
    # Add an existing source to a Factlink
    @factlink = Factlink.find(params[:factlink_id])
    @source   = Factlink.find(params[:source_id])

    @source.set_parent @factlink.id
    @factlink.add_child_as_supporting(@source, current_user)
    
    render "add_source_to_factlink"
  end
  
  def add_source_as_weakening
    # Add an existing source to a Factlink
    @factlink = Factlink.find(params[:factlink_id])
    @source   = Factlink.find(params[:source_id])

    @source.set_parent @factlink.id
    @factlink.add_child_as_weakening(@source, current_user)
    
    render "add_source_to_factlink"
  end

  def add_factlink_to_parent_as_supporting
    # Add a Factlink as source for another Factlink
    @factlink = Factlink.find(params[:factlink_id])
    @parent   = Factlink.find(params[:parent_id])

    @factlink.set_parent @parent.id
    @parent.add_child_as_supporting(@factlink, current_user)
    
    render "add_factlink_to_parent"
  end
  
  def add_factlink_to_parent_as_weakening
    # Add a Factlink as source for another Factlink
    @factlink = Factlink.find(params[:factlink_id])
    @parent   = Factlink.find(params[:parent_id])

    @factlink.set_parent @parent.id
    @parent.add_child_as_weakening(@factlink, current_user)
    
    render "add_factlink_to_parent"
  end
  
  
  def remove_factlink_from_parent
    
    # TODO: Only allow if user added the source earlier on
    
    # Remove a Factlink from it's parent
    @factlink = Factlink.find(params[:factlink_id])
    parent    = Factlink.find(params[:parent_id])
    
    if @factlink.added_to_parent_by_current_user(parent, current_user)
      # Only remove if the user added this source
      puts "Removing child"
      parent.remove_child(@factlink)
      parent.save
    end
  end
  
  def update
    @factlink = Factlink.find(params[:id])

    respond_to do |format|
      if @factlink.update_attributes(params[:factlink])
        format.html { redirect_to(@factlink, 
                      :notice => 'Factlink top was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def believe
    parent = Factlink.find(params[:parent_id])

    @factlink = Factlink.find(params[:id])
    @factlink.add_believer(current_user, parent)

    render "update_source_li"
  end
  
  def doubt
    parent = Factlink.find(params[:parent_id])
    
    @factlink = Factlink.find(params[:id])
    @factlink.add_doubter(current_user, parent)

    render "update_source_li"
  end
  
  def disbelieve
    parent = Factlink.find(params[:parent_id])

    @factlink = Factlink.find(params[:id])
    @factlink.add_disbeliever(current_user, parent)

    render "update_source_li"
  end
  
  def set_opinion
    allowed_types = ["beliefs", "doubts", "disbeliefs"]
    type = params[:type]
    
    if allowed_types.include?(type)
      @type = type
      
      @parent = Factlink.find(params[:parent_id])

      @factlink = Factlink.find(params[:child_id])
      @factlink.set_opinion(current_user, type, @parent)
    else   
      render :json => {"error" => "type not allowed"}
      return false
    end
  end
  
  def set_relevance
    @parent = Factlink.find(params[:parent_id])
    @child  = Factlink.find(params[:child_id])
    
    # TODO: validate the type
    type = params[:type]
    
    @parent.set_relevance_for_user(@child, type, current_user)
  end
  
  
  # Users that interacted with this Factlink
  def interaction_users_for_factlink
    @factlink = Factlink.find(params[:factlink_id])
    
    @believers    = @factlink.believers
    @doubters     = @factlink.doubters
    @disbelievers = @factlink.disbelievers
    
    
  end
  
  # Search 
  def search
    @row_count = 50
    row_count = 50
     
    if params[:s] 
      solr_result = Factlink.search() do

        keywords params[:s], :fields => [:displaystring]
        order_by sort_column, sort_direction
        paginate :page => params[:page] , :per_page => row_count

        adjust_solr_params do |sunspot_params|
          sunspot_params[:rows] = row_count
        end

      end
      
      @factlinks = solr_result.results
    else
      # will_paginate sorting doesn't work very well on arrays.. Fixed it..
      @factlinks = WillPaginate::Collection.create( params[:page] || 1, row_count ) do |pager|
        start = (pager.current_page-1)*row_count
        
        # Sorting & filtering done by mongoid
        results = Factlink.all(:sort => [[sort_column, sort_direction]]).with_site_as_parent.skip(start).limit(row_count).to_a
        
        pager.replace(results)
      end
    end
        
    respond_to do |format|
      format.html { render :layout => "accounting" }# search.html.erb
      format.js
    end
  end
  
  private
  def sort_column
    Factlink.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  
end