class FactsController < ApplicationController

  helper_method :sort_column, :sort_direction

  before_filter :store_fact_for_non_signed_in_user, :only => [:create]

  # Change this to :except, in stead of :only. 
  before_filter :authenticate_user!, :only => [:new, 
    :edit, 
    :create, 
    :update,
    :add_factlink_to_parent,
    :remove_factlink_from_parent,
    :believe,
    :doubt,
    :disbelieve,
    :set_opinion,
    :add_supporting_evidence,
    :add_weakening_evidence,
    :toggle_opinion_on_fact,
    :toggle_relevance_on_fact_relation
    ]
  
  layout "client"
  
  # Check if the user is signed in before adding a Fact.
  # If this is not the case, store the params in a session variable,
  # so the Fact can be created after logging in.
  def store_fact_for_non_signed_in_user
    unless user_signed_in?
      session[:fact_to_create] = params
    end
  end

  def factlinks_for_url
    url = params[:url]
    site = Site.first(:conditions => { :url => url })
    
    @facts = if site
             then site.facts
             else []
             end

    # Render the result with callback, 
    # so JSONP can be used (for Internet Explorer)
    render :json => @facts.to_json( :only => [:_id, :displaystring], :methods => :score_dict_as_percentage  ), 
                                        :callback => params[:callback]  
  end

  def show
    @fact = Fact.find(params[:id])
    
    # TODO: Generate ajax request for potential sources
    # All sources that are not part of this factlink yet

    # Create copy of ids array
    # not_allowed_child_ids = Array.new(@factlink.child_ids)
    # not_allowed_child_ids << @factlink.id
    
    # not_allowed_parent_ids = Array.new(@factlink.parent_ids)
    # not_allowed_parent_ids << @factlink.id
    
    # @potential_childs = Fact.not_in( :_id => not_allowed_child_ids )
    # @potential_parents = Fact.not_in( :_id => not_allowed_parent_ids )
    
    ids = @fact.fact_relations_ids
    ids << @fact.id
    
    @potential_evidence = Fact.where(:_id.nin => ids)
  end
  
  def new
    @fact = Fact.new
  end
  
  def edit
    @fact = Fact.find(params[:id])
    ids = FactRelation.where(:_id.in => @fact.fact_relation_ids).map { |fr| fr.from_fact.value }
    ids << @fact.id
    
    @potential_evidence = Fact.where(:_id.nin => ids)
  end
  
  # Prepare for create
  def prepare
    render :template => 'facts/prepare', :layout => nil
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

    render :template => 'facts/intermediate', :layout => nil
  end

  def create
    # Creating a Fact requires a url and fact ( > displaystring )
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
    
    # Create the Fact
    @factlink = Fact.create!(:displaystring => displaystring, 
                             :created_by => current_user,
                             :site => site)

    # Redirect to edit action
    redirect_to :action => "edit", :id => @factlink.id
  end
  
  def add_supporting_evidence
    # Add existing evidence to a Fact
    @fact     = Fact.find(params[:fact_id])
    @evidence = Fact.find(params[:evidence_id])

    @fact_relation = @fact.add_evidence(:supporting, @evidence, current_user)
    
    render "add_source_to_factlink"
  end
  
  def add_weakening_evidence
    # Add existing evidence to a Fact
    @fact     = Fact.find(params[:fact_id])
    @evidence = Fact.find(params[:evidence_id])

    @fact_relation = @fact.add_evidence(:weakening, @evidence, current_user)
    
    render "add_source_to_factlink"
  end



  # Adding the current fact to another existing fact as evidence
  # Is this still the way we want to use this in the future UI?
  deprecate # move to facts#add_supporting_evidence
  def add_factlink_to_parent_as_supporting
    # Add a Fact as source for another Fact
    @fact     = Fact.find(params[:fact_id])
    @evidence = Fact.find(params[:evidence_id])
    
    # Is this correct?
    @factlink = FactRelation.get_or_create(@evidence, :supporting, @fact, current_user)
    
    render "add_factlink_to_parent"
  end
  
  
  # Adding the current fact to another existing fact as evidence
  # Is this still the way we want to use this in the future UI?

  deprecate # move to facts#add_weakening_evidence
  def add_factlink_to_parent_as_weakening
    # Add a Fact as source for another Fact
    @factlink = Fact.find(params[:factlink_id])
    @parent   = Fact.find(params[:parent_id])

    # Is this correct?
    @factlink = FactRelation.get_or_create(@evidence, :weakening, @fact, current_user)
    
    render "add_factlink_to_parent"
  end
  
  
  
  def remove_factlink_from_parent
    
    # TODO: Only allow if user added the source earlier on
    
    # Remove a Fact from it's parent
    @factlink = Fact.find(params[:factlink_id])
    parent    = Fact.find(params[:parent_id])
    
    if @factlink.added_to_parent_by_current_user(parent, current_user)
      # Only remove if the user added this source
      puts "Removing child"
      parent.remove_child(@factlink)
      parent.save
    end
  end
  
  
  

  def update
    @factlink = Fact.find(params[:id])

    respond_to do |format|
      if @factlink.update_attributes(params[:factlink])
        format.html { redirect_to(@factlink, 
                      :notice => 'Factlink top was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  

  # Set or unset the opinion on a Factrelation
  def toggle_opinion_on_fact
    allowed_types = ["beliefs", "doubts", "disbeliefs"]
    type = params[:type]
    
    if allowed_types.include?(type)
      @fact_relation = FactRelation.find(params[:fact_relation_id])
      @fact_relation.get_from_fact.toggle_opinion(type, current_user)
    else   
      render :json => {"error" => "type not allowed"}
      return false
    end
  end
  
  # Set or unset the relevance on a Factrelation
  def toggle_relevance_on_fact_relation
    allowed_types = ["beliefs", "doubts", "disbeliefs"]
    type = params[:type]
    
    if allowed_types.include?(type)
      @fact_relation = FactRelation.find(params[:fact_relation_id])
      @fact_relation.toggle_opinion(type, current_user)
    else
      render :json => {"error" => "type not allowed"}
      return false
    end
  end
  
  
  # Users that interacted with this Fact
  def interaction_users_for_factlink
    @fact         = Fact.find(params[:factlink_id])
    
    @believers    = @factlink.opiniated(:beliefs)
    @doubters     = @factlink.opiniated(:doubts)
    @disbelievers = @factlink.opiniated(:disbeliefs)    
    
  end
  
  # Search 
  def search
    @row_count = 50
    row_count = @row_count
        
    if params[:s]
      solr_result = Fact.search() do

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
        results = Fact.all(:sort => [[sort_column, sort_direction]]).skip(start).limit(row_count).to_a
        
        pager.replace(results)
      end
    end
        
    respond_to do |format|
      format.html { render :layout => "accounting" }# search.html.erb
      format.js
    end
  end
  
  def indication
    respond_to do |format|
      format.js
    end
  end
  
  private
  def sort_column
    Fact.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  
end