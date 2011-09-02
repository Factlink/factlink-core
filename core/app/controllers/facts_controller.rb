class FactsController < ApplicationController


  layout "client"
  
  helper_method :sort_column, :sort_direction

  before_filter :store_fact_for_non_signed_in_user, 
    :only => [:create]

  before_filter :authenticate_user!, 
    :except => [
      :show, 
      :prepare_new,
      :prepare_evidence, 
      :intermediate, 
      :search, 
      :indication]
                                               
  before_filter :load_fact, 
    :only => [
      :show,
      :edit,
      :destroy,
      :update,
      :bubble,
      :opinion]
                                                        
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
    # render :partial => 'home/snippets/fact/fact_container'
  end

  def new
    @fact = Fact.new
  end

  def edit
  end

  def bubble
    render :partial => "facts/partial/fact_bubble", 
	            :locals => {  :fact => @fact }
  end

  # Prepare for create
  def prepare_new
    render :template => 'facts/javascript/prepare_new.js.erb', :content_type => "application/javascript"
  end
  
  def prepare_evidence
    render :template => 'facts/javascript/prepare_evidence.js.erb', :content_type => "application/javascript"
  end

  # Prepare for create
  def intermediate
    # TODO: Sanitize for XSS
    @url = params[:url]
    @passage = params[:passage]
    @fact = params[:fact]
    @title = params[:title]
    render :template => 'facts/intermediate', :layout => nil
  end

  def create
    @fact = create_fact(params[:url], params[:fact], params[:title])
    redirect_to :action => "edit", :id => @fact.id
  end

  def create_fact_as_evidence
    evidence = create_fact(params[:url], params[:fact], params[:title])
    @fact_relation = add_evidence(evidence.id, params[:type].to_sym, params[:fact_id])
  end

  def add_supporting_evidence
    @fact_relation = add_evidence(params[:evidence_id], :supporting, params[:fact_id])
    
    # A FactRelation will not get created if it will cause a loop
    if @fact_relation.nil?
      render "adding_evidence_not_possible"
    else
      render "add_source_to_factlink"
    end
  end

  def add_weakening_evidence
    fact_id     = params[:fact_id]
    evidence_id = params[:evidence_id]
        
    @fact_relation = add_evidence(evidence_id, :weakening, fact_id)
    
    # A FactRelation will not get created if it will cause a loop
    if @fact_relation.nil?
      render "adding_evidence_not_possible"
    else
      render "add_source_to_factlink"
    end
  end
  
  def add_new_evidence
    type = params[:type].to_sym
    if type == :weakening
      self.add_weakening_evidence
    elsif type == :supporting
      self.add_supporting_evidence
    end
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

  def opinion
    render :json => {"opinions" => @fact.get_opinion.as_percentages}
  end

  def set_opinion    
    allowed_types = [:beliefs, :doubts, :disbeliefs]
    type = params[:type].to_sym
    
    if allowed_types.include?(type)
      if params[:fact_type] == "fact"
          @fact = Fact[params[:fact_id]] # This fails with a nasy error for an invalid error
          @fact.add_opinion(type, current_user.graph_user)
          render :nothing => true
      elsif params[:fact_type] == "fact_relation"
          @fact_relation = FactRelation[params[:fact_id]]
          @fact_relation.add_opinion(type, current_user.graph_user)
          render :nothing => true
      else
        render :json => {"error" => "fact type not allowed"}
      end
    else 
      render :json => {"error" => "type not allowed"}
      return false
    end
  end

  def remove_opinions   
      if params[:fact_type] == "fact"
          @fact = Fact[params[:fact_id]]
          @fact.remove_opinions(current_user.graph_user)
          render :nothing => true
      elsif params[:fact_type] == "fact_relation"
          @fact_relation = FactRelation[params[:fact_id]]
          @fact.remove_opinions(current_user.graph_user)
          render :nothing => true
      else
        render :json => {"error" => "fact type not allowed"}
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
    
    @potential_evidence = Fact.all.except(:data_id => intersecting_ids).sort(:order => "DESC")
  end    

  def load_fact # private
    @fact = Fact[params[:id]]
  end
  
  def add_evidence(evidence_id, type, fact_id) # private  
    type = type.to_sym  
    fact     = Fact[fact_id]
    evidence = Fact[evidence_id]

    # Create FactRelation
    fact_relation = fact.add_evidence(type, evidence, current_user)   
    evidence.add_opinion(:beliefs, current_user.graph_user)
    fact_relation.add_opinion(:beliefs, current_user.graph_user)    
    fact_relation
  end
  
  def create_fact(url, displaystring, title) # private
    @site = Site.find(:url => url).first || Site.create(:url => url, :title => title)
    @fact = Fact.create(
      :created_by => current_user.graph_user,
      :site => @site
    )
    @fact.data.displaystring = displaystring    
    @fact.data.save
    @fact
  end
  
end
