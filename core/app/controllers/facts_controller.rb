class FactsController < ApplicationController

  layout "client"
  
  helper_method :sort_column, :sort_direction

  before_filter :store_fact_for_non_signed_in_user, 
    :only => [:create]

  before_filter :authenticate_user!, 
    :except => [
      :show, 
      :prepare, 
      :intermediate, 
      :search, 
      :indication]
                                               
  before_filter :load_fact, 
    :only => [
      :show,
      :edit,
      :destroy,
      :update]
                                                        
  before_filter :potential_evidence, 
    :only => [
      :show,
      :edit]

  # Check if the user is signed in before adding a Fact.
  # If this is not the case, store the params in a session variable,
  # so the Fact can be created after logging in.
  def store_fact_for_non_signed_in_user
    unless user_signed_in?
      session[:fact_to_create] = params
    end
  end

  def show
  end

  def new
    @fact = Fact.new
  end

  def edit
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

    render :template => 'facts/intermediate', :layout => nil
  end

  def create
    # Creating a Fact requires a url and fact ( > displaystring )
    # TODO: Refactor 'fact' to 'displaystring' for internal consistency

    # Get or create the website on which the Fact is located
    
    puts "\nGetting or creating Site with params: #{params[:url]}\n"
    
    
    site = Site.find_or_create_by(params[:url])

    # TODO: This can be changed to use only displaystring when the above
    # refactor is done.
    if params[:fact]
      displaystring = params[:fact]
    else
      displaystring = params[:factlink][:displaystring]
    end

    @fact = Fact.new
    @fact.displaystring = displaystring
    @fact.created_by = current_user.graph_user
    @fact.site = site
    @fact.save

    # Required for the Ohm Model
    site.facts << @fact

    # Redirect to edit action
    redirect_to :action => "edit", :id => @fact.id
  end

  def add_supporting_evidence
    add_evidence(:supporting)
  end

  def add_weakening_evidence
    add_evidence(:weakening)
  end

  def destroy
    if current_user.graph_user == @fact.created_by
      @fact_id = @fact.id
      @fact.delete_cascading
    end
  end

  def update
    @factlink = Fact[params[:id]]

    respond_to do |format|
      if @factlink.update_attributes(params[:factlink])
        format.html { redirect_to(@factlink,
          :notice => 'Factlink top was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # Set or unset the opinion on a FactRelation
  def toggle_opinion_on_fact
    allowed_types = ["beliefs", "doubts", "disbeliefs"]
    type = params[:type]

    if allowed_types.include?(type)
      @fact_relation = FactRelation[params[:fact_relation_id]]
      @fact_relation.get_from_fact.toggle_opinion(type, current_user)
    else
      render :json => {"error" => "type not allowed"}
      return false
    end
  end

  # Set or unset the relevance on a FactRelation
  def toggle_relevance_on_fact_relation
    allowed_types = ["beliefs", "doubts", "disbeliefs"]
    type = params[:type]

    if allowed_types.include?(type)
      @fact_relation = FactRelation[params[:fact_relation_id]]
      @fact_relation.toggle_opinion(type, current_user)
    else
      render :json => {"error" => "type not allowed"}
      return false
    end
  end

  # Users that interacted with this Fact
  def interaction_users_for_factlink
    @fact         = Fact[params[:factlink_id]]

    @believers    = @fact.opiniated(:beliefs)
    @doubters     = @fact.opiniated(:doubts)
    @disbelievers = @fact.opiniated(:disbeliefs)
  end

  # Search
  # Not using the same search for the client popup, since we probably want\
  # to use a more advanced search on the Factlink website.
  def search
    @row_count = 50
    row_count = @row_count

    if params[:s]
      solr_result = FactData.search() do

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
        results = FactData.all(:sort => [[sort_column, sort_direction]]).skip(start).limit(row_count).to_a
        pager.replace(results)
      end
    end

    respond_to do |format|
      format.html { render :layout => "accounting" }# search.html.erb
      format.js
    end
  end

  # Search in the client popup.
  def client_search
    # Need fact for rendering in the template
    @fact = Fact[params[:fact_id].to_i]

    @row_count = 20
    row_count = @row_count

    if params[:s]
      solr_result = FactData.search() do

        keywords params[:s], :fields => [:displaystring]
        order_by sort_column, sort_direction
        paginate :page => params[:page] , :per_page => row_count

        adjust_solr_params do |sunspot_params|
          sunspot_params[:rows] = row_count
        end
      end

      @fact_data = solr_result.results
    else
      # will_paginate sorting doesn't work very well on arrays.. Fixed it..
      @fact_data = WillPaginate::Collection.create( params[:page] || 1, row_count ) do |pager|
        start = (pager.current_page-1)*row_count

        # Sorting & filtering done by mongoid
        results = FactData.all(:sort => [[sort_column, sort_direction]]).skip(start).limit(row_count).to_a
        pager.replace(results)
      end
    end

    # Return the actual Facts in stead of FactData
    @facts = @fact_data.map { |fd| fd.fact }
    potential_evidence

    # Exclude the Facts that are already supporting AND weakening
    @facts = @facts & potential_evidence.to_a

    respond_to do |format|
      format.js
    end
  end

  def indication
    respond_to do |format|
      format.js
    end
  end

  private
  def sort_column # private
    Fact.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction # private
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def potential_evidence # private
    # TODO Fix this very quick please. Nasty way OhmModels handles querying\
    # and filtering. Can't use the object ID, so using a workaround with :data_id's
    # Very nasty :/
    supporting_fact_ids = @fact.evidence(:supporting).map { |i| i.get_from_fact.data_id }
    weakening_fact_ids  = @fact.evidence(:weakening).map { |i| i.get_from_fact.data_id }
    
    intersecting_ids = supporting_fact_ids & weakening_fact_ids
    intersecting_ids << @fact.data_id
    
    @potential_evidence = Fact.all.except(:data_id => intersecting_ids)
  end    

  def load_fact # private
    @fact = Fact[params[:id]]
  end
  
  def add_evidence(type) # private
    @fact     = Fact[params[:fact_id]]
    @evidence = Fact[params[:evidence_id]]

    @fact_relation = @fact.add_evidence(type, @evidence, current_user)

    # A FactRelation will not get created if it will cause a loop
    if @fact_relation.nil?
      render "adding_evidence_not_possible"
    else
      render "add_source_to_factlink"
    end
  end
end
