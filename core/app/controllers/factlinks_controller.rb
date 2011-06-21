class FactlinksController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update]
  
  layout "client"

  def factlinks_for_url
    url = params[:url]
    site = Site.first(:conditions => { :url => url })
    
    @factlinks = if site
                 then site.factlinks
                 else []
                 end

    # Render the result with callback, 
    # so JSONP can be used (for Internet Explorer)
    render :json => @factlinks.to_json( :only => [:_id, :displaystring] ), 
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
    render :template => 'factlink_tops/prepare', :layout => nil
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

    render :template => 'factlink_tops/intermediate', :layout => nil
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
  
  
  def create_as_source
    parent_id = params[:factlink][:parent_id]

    
    # Cleaner way for doing this?
    # Cannot create! the object with paramgs[:factlink],
    # since we have to add the current_user as well.
    # 
    # Adding current_user after create and saving again
    # is one unneeded save extra.
    displaystring = params[:factlink][:displaystring]
    url = params[:factlink][:url]
    content = params[:factlink][:content]

    # Create the Factlink
    @factlink = Factlink.create!(:displaystring => displaystring,
                                    :url => url,
                                    :content => content,
                                    :created_by => current_user)

    # Set the correct parent
    @factlink.set_parent parent_id
    
    @parent = Factlink.find(parent_id)
  end
  
  def add_source_to_factlink
    @factlink = Factlink.find(params[:factlink_id])
    @source   = Factlink.find(params[:source_id])
    
    @source.set_parent @factlink.id
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

      @factlink = Factlink.find(params[:id])
      @factlink.set_opinion(current_user, type, @parent)
    else   
      render :json => {"error" => "type not allowed"}
      return false
    end
  end
  
  
  # Search 
  def search
    @per_page = 50
     
    if params[:s] 
      solr_result = Factlink.search() do
        keywords params[:s], :fields => [:displaystring]
        order_by sort_column, sort_direction
        paginate :page => params[:page], :per_page => @per_page
      end
      
      @factlinks = solr_result.results
    else
      # will_paginate sorting doesn't work very well on arrays.. Fixed it..
      @factlinks = WillPaginate::Collection.create( params[:page] || 1, @per_page ) do |pager|
        start = (pager.current_page-1)*@per_page
        
        # Sorting & filtering done by mongoid
        results = Factlink.all(:sort => [[sort_column, sort_direction]]).with_site_as_parent.skip(start).limit(per_page).to_a
        
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