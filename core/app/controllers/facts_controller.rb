class FactsController < ApplicationController

  helper_method :sort_column, :sort_direction

  before_filter :store_fact_for_non_signed_in_user, :only => [:create]

  # TODO Change this to :except, in stead of :only.
  before_filter :authenticate_user!, :only => [:new,
                                               :edit,
                                               :create,
                                               :update,
                                               :destroy,
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
                                               
  before_filter { @fact = Fact[params[:id]]}, :only => [:show,
                                                        :edit,
                                                        :destroy,
                                                        :update
                                                        ]
  after_filter :potential_evidence, :only => [:show,
                                              :edit
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

  #TODO shouldn't this be in the site controller?
  def factlinks_for_url
    url = params[:url]
    site = Site.find(:url => url).first

    @facts = if site
    then site.facts.to_a
    else []
    end

    # Render the result with callback,
    # so JSONP can be used (for Internet Explorer)
    render :json => @facts , :callback => params[:callback]
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
    site = Site.find_or_create_by(:url => params[:url])

    # TODO: This can be changed to use only displaystring when the above
    # refactor is done.
    if params[:fact]
      displaystring = params[:fact]
    else
      displaystring = params[:factlink][:displaystring]
    end

    # Create the Fact
    @factlink = Fact.create(:displaystring => displaystring,
                              :created_by => current_user.graph_user,
                              :site => site)

    # Required for the Ohm Model, doesn't set the relation itself?
    site.facts << @factlink

    # Redirect to edit action
    redirect_to :action => "edit", :id => @factlink.id
  end

  def add_supporting_evidence
    add_evidence(:supporting)
  end

  def add_weakening_evidence
    add_evidence(:weakening)
  end

  def add_evidence(type)
    @fact     = Fact[params[:fact_id]]
    @evidence = Fact[params[:evidence_id]]

    puts "\n\nI am the fact: #{@fact.id}"

    @fact_relation = @fact.add_evidence(type, @evidence, current_user)

    render "add_source_to_factlink"
  end
  
  def destroy
    if current_user.graph_user == @fact.created_by
      @fact.delete_cascading
    end
  end
  

  def update
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
        @fact_relation = FactRelation[params[:fact_relation_id]]
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
      fact_id = params[:fact_id].to_i
      @fact = Fact[fact_id]

      @row_count = 2
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

      @facts = @fact_data.map { |fd| fd.fact }

      puts "\n\n\n#{@facts}"

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
    def sort_column
      Fact.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
    
    def potential_evidence_for_fact(fact)
      #TODO potential evidence should be a list of facts which can be added as supporting or weakening evidence

      # Don't show self in potential evidence

      # Ohm Model workaround. Can't except a model on its ID\
      # so use the data_id to filter it out...

      @potential_evidence = Fact.all.except(:data_id => fact.data_id)
    end

    def potential_evidence
      #TODO potential evidence should be a list of facts which can be added as supporting or weakening evidence
      @potential_evidence = Fact.all
    end    


  end
