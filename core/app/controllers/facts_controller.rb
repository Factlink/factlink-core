class FactsController < ApplicationController

  layout "client"
  
  helper_method :sort_column, :sort_direction

  before_filter :store_fact_for_non_signed_in_user, 
    :only => [:create]

  before_filter :authenticate_user!, 
    :except => [
      :show,
      :intermediate, 
      :search,
      :indicator]

  before_filter :load_fact, 
    :only => [
      :show,
      :edit,
      :destroy,
      :update,
      :bubble,
      :opinion,
      :evidence_search,
      :evidenced_search]
  before_filter :potential_evidence, 
    :only => [
      :show,
      :edit]

  around_filter :allowed_type,
    :only => [:set_opinion ]

  # Check if the user is signed in before adding a Fact.
  # If this is not the case, store the params in a session variable,
  # so the Fact can be created after logging in.
  def store_fact_for_non_signed_in_user
    unless user_signed_in?
      session[:fact_to_create] = params
    end
  end


  def index
    respond_to do |format|
      format.json { render :json => Fact.all }
     end
  end

  def show
    @title = @fact.data.displaystring # The html <title>
    if params[:showevidence] == "true"
      @showEvidence = true
    else
      @showEvidence = false
    end
    respond_to do |format|
      format.json { render :json => @fact }
      format.html
    end
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
  def intermediate
    # TODO: Sanitize for XSS
    @url = params[:url]
    @passage = params[:passage]
    @fact = params[:fact]
    @title = params[:title]
    @opinion = params[:opinion]
    
    render :template => 'facts/intermediate', :layout => nil
  end

  def create
    @fact = create_fact(params[:url], params[:fact], params[:title])
    
    if params[:opinion]
      @fact.add_opinion(params[:opinion].to_sym, current_user.graph_user)
      @fact.calculate_opinion(1)
    end
    
    respond_to do |format|
      format.json { render :json => @fact }
      format.html { redirect_to :action => "edit", :id => @fact.id }
    end
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


  def add_supporting_evidenced
    @fact_relation = add_evidence(params[:evidence_id], :supporting, params[:fact_id])
    
    # A FactRelation will not get created if it will cause a loop
    if @fact_relation.nil?
      render "adding_evidence_not_possible"
    else
      render "add_evidenced_to_factlink"
    end
  end

  def add_weakening_evidenced
    fact_id     = params[:fact_id]
    evidence_id = params[:evidence_id]
        
    @fact_relation = add_evidence(evidence_id, :weakening, fact_id)
    
    # A FactRelation will not get created if it will cause a loop
    if @fact_relation.nil?
      render "adding_evidence_not_possible"
    else
      render "add_evidenced_to_factlink"
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
    @fact = Fact[params[:id]]
    respond_to do |format|
      if @fact.update_attributes(params[:factlink])
        format.html { redirect_to(@fact,
          :notice => 'Fact was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def update_title
    # Gets 'title-[id]' 'cuz it must be unique and Jeditable is using the elements 'id'
    # Strip first six characters to find the ID
    id = params[:id].slice(6..(params[:id].length - 1))
    @fact = Fact[id]

    if current_user.graph_user == @fact.created_by      
      @fact.data.title = params[:value]
      @fact.data.save
    end
    
    render :text => @fact.data.title
  end

  def opinion
    render :json => {"opinions" => @fact.get_opinion(3).as_percentages}, :callback => params[:callback], :content_type => "text/javascript" 
  end


  def set_opinion
    type = params[:type].to_sym
    @fact = Basefact[params[:fact_id]] 
    @fact.add_opinion(type, current_user.graph_user)
    @fact.calculate_opinion(2)
    render :json => [[@fact],@fact.evidenced_facts].flat_map {|x| x }
  end

  def remove_opinions
    @fact = Basefact[params[:fact_id]]
    @fact.remove_opinions(current_user.graph_user)
    @fact.calculate_opinion(2)
    render :json => [[@fact],@fact.evidenced_facts].flat_map {|x| x }
  end

  def evidenced_search
    potential_evidenced
    internal_search(@potential_evidenced.to_a)
    respond_to do |format|
      format.js
    end
  end


  def evidence_search
    potential_evidence
    internal_search(@potential_evidence.to_a)
    respond_to do |format|
      format.js
    end
  end

  # Search in the client popup.  
  def internal_search(eligible_facts)
    @page = params[:page]
    page = @page
    @row_count = 4
    row_count = @row_count

    solr_result = FactData.search() do
      keywords params[:s] || ""
      
      order_by sort_column, sort_direction
      paginate :page => page , :per_page => row_count
      
      # Exclude the Facts that are already supporting AND weakening
      with(:fact_id).any_of(eligible_facts.map{|fact| fact.id})
    end

    @fact_data = solr_result.results

    # Return the actual Facts in stead of FactData
    @facts = @fact_data.map { |fd| fd.fact }
  end
  
 private
  def sort_column # private
    FactData.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction # private
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def potential_evidence # private
    # TODO Fix this very quick please. Nasty way OhmModels handles querying\
    # and filtering. Can't use the object ID, so using a workaround with :data_id's
    # Very nasty :/
    supporting_fact_ids = @fact.evidence(:supporting).map { |i| i.from_fact.data_id }
    weakening_fact_ids  = @fact.evidence(:weakening).map { |i| i.from_fact.data_id }
    intersecting_ids = supporting_fact_ids & weakening_fact_ids
    intersecting_ids << @fact.data_id
    
    @potential_evidence = Fact.all.except(:data_id => intersecting_ids).sort(:order => "DESC")
  end    

  def potential_evidenced # private
    # TODO Fix this very quick please. Nasty way OhmModels handles querying\
    # and filtering. Can't use the object ID, so using a workaround with :data_id's
    # Very nasty :/
    supporting_fact_ids = FactRelation.find(:from_fact_id => @fact.id, :type => :supporting).all.map {|fr| fr.fact.data_id}
    weakening_fact_ids = FactRelation.find(:from_fact_id => @fact.id, :type => :weakening).all.map {|fr| fr.fact.data_id}
    
    intersecting_ids = supporting_fact_ids & weakening_fact_ids
    intersecting_ids << @fact.data_id
    
    @potential_evidenced = Fact.all.except(:data_id => intersecting_ids).sort(:order => "DESC")
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

  private
  def allowed_type
    allowed_types = [:beliefs, :doubts, :disbeliefs]
    type = params[:type].to_sym
    if allowed_types.include?(type)
      yield
    else 
      render :json => {"error" => "type not allowed"}, :status => 500
      return false
    end
  end
  
end
