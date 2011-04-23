class FactlinksController < ApplicationController


  def create
    required_params = %W[url fact callback]
    error = false
    
    # Validate presence of all required parameters
    # If fail, return error message.
    required_params.each do |param|
      if params[param].nil?
        error = true
        render :json => "{\"error\": #{error}, \"message\": \"The following parameters are required: url, fact, callback.\"}", :callback => params[:callback]
        # return is required to jump out of function
        return false
      end
    end
    
    # Get or create the website on which the Fact is located.
    site = Site.find_or_create_by(:url => params[:url])

    # Create the Factlink.
    new_factlink = FactlinkTop.create!(:displaystring => params[:fact])
    
    # And add Factlink to the Site.
    site.factlink_tops << new_factlink
    
    added = true
    status = true
    match_id = new_factlink.id
    
    # Create the result payload
    res_dict = {}
    res_dict[:added] = added
    res_dict[:status] = status
    res_dict[:match_id] = match_id
    
    render :json => res_dict, :callback => params[:callback]
    
  end

  def add_sub
    @factlink_top = FactlinkTop.find(params[:id])
    
    title = params[:title]
    content = params[:content]
    url = params[:url]
    
    sub = FactlinkSub.new(:title => title, :content => content, :url => url)
    sub.save
    
    @factlink_top.factlink_subs << sub
    @factlink_top.save
    
    render :json => { :status => true }, :callback => params[:callback]
  end
  
  def add_tag
    # TODO: Check if tag already exists
    @factlink_top = FactlinkTop.find(params[:id])
    
    tag = params[:tag]
    current_tags = @factlink_top.tags
    new_tags = current_tags << ", #{tag}"
    
    @factlink_top.tags = new_tags
    @factlink_top.save
    
    render :json => { :status => true }, :callback => params[:callback]
  end










  ##########
  # Retrieve the Factlinks for this URL
  # TODO: Will be replaced soon. URL matching is quick for development,
  # but we want to check Factlinks in the complete text on the website.
  def factlink_tops_for_url
    # TODO: Error handling when no url is given.
    @url = params[:url]
    
    # Should only give 0 or 1 result(s), 
    # since we are currently making an exact match on the URL.
    sites = Site.where(:url => @url)
    
    # Get the entries for the Site if found, else return an empty array
    if sites.count > 0 then @factlinks = sites[0].factlink_tops.entries else @factlinks = [] end
  
    # Render the result with callback, so JSONP can be used (for Internet Explorer)
    render :json => @factlinks.to_json(:only => [:_id, :displaystring]), :callback => params[:callback]
  end
  
  
  ##########
  # Retrieve the FactlinkSubs for the submitted Factlink.
  def factlink_subs_for_factlink_id
    # TODO: Error handling when no ID is given.
    id = params[:factlink_top_id] #|| '4d6651f2c09808d296000001'
    
    factlink_top = FactlinkTop.find(id)
    @factlink_subs = factlink_top.factlink_subs.entries
    
    # Render the result with callback, so JSONP can be used (for Internet Explorer)
    render :json => @factlink_subs, :callback => params[:callback]
  end


  def new
    required_params = %W[url fact callback]
    error = false
    
    # Validate presence of all required parameters
    # If fail, return error message.
    required_params.each do |param|
      if params[param].nil?
        error = true
        render :json => "{\"error\": #{error}, \"message\": \"The following parameters are required: url, fact, callback.\"}", :callback => params[:callback]
        # return is required to jump out of function
        return false
      end
    end

    
    # Use Solr to find matching facts
    @matched_facts = FactlinkTop.search() do
      keywords(params[:fact]) { minimum_match 1 }
    end
    
    # Check for matching results
    if @matched_facts.results.count > 0      
      best_match = @matched_facts.hits()[0]
    end
    
    # Add it, unless we have a score, and score higher then threshold
    should_add = true
    if best_match
      should_add = best_match.score < 1.0
    end
    
    # Check if hit ratio surpasses threshold    
    unless should_add
      added = false
      status = true
      match_id = best_match.result.id

    else
      # Get or create the website on which the Fact is located.
      site = Site.find_or_create_by(:url => params[:url])

      # Create the Factlink.
      new_factlink = FactlinkTop.create!(:displaystring => params[:fact])
      
      # And add Factlink to the Site.
      site.factlink_tops << new_factlink
      
      added = true
      status = true
      match_id = new_factlink.id
    end 
    
    # Create the result payload
    res_dict = {}
    res_dict[:added] = added
    res_dict[:status] = status
    res_dict[:match_id] = match_id
    
    render :json => res_dict, :callback => params[:callback]
  end

#   ##########
#   # GET /factlinks
#   # GET /factlinks.xml
#   def index
#     @factlinks = Factlink.all
# 
#     respond_to do |format|
#       format.html # index.html.erb
#       format.xml  { render :xml => @factlinks }
#     end
#   end
# 
#   # GET /factlinks/1
#   # GET /factlinks/1.xml
#   def show
#     @factlink = Factlink.find(params[:id])
# 
#     respond_to do |format|
#       format.html # show.html.erb
#       format.xml  { render :xml => @factlink }
#     end
#   end
# 
#   # GET /factlinks/new
#   # GET /factlinks/new.xml
#   def new
#     @factlink = Factlink.new
# 
#     respond_to do |format|
#       format.html # new.html.erb
#       format.xml  { render :xml => @factlink }
#     end
#   end
# 
#   # GET /factlinks/1/edit
#   def edit
#     @factlink = Factlink.find(params[:id])
#   end
# 
#   # POST /factlinks
#   # POST /factlinks.xml
#   def create
#     @factlink = Factlink.new(params[:factlink])
# 
#     respond_to do |format|
#       if @factlink.save
#         format.html { redirect_to(@factlink, :notice => 'Factlink was successfully created.') }
#         format.xml  { render :xml => @factlink, :status => :created, :location => @factlink }
#       else
#         format.html { render :action => "new" }
#         format.xml  { render :xml => @factlink.errors, :status => :unprocessable_entity }
#       end
#     end
#   end
# 
#   # PUT /factlinks/1
#   # PUT /factlinks/1.xml
#   def update
#     @factlink = Factlink.find(params[:id])
# 
#     respond_to do |format|
#       if @factlink.update_attributes(params[:factlink])
#         format.html { redirect_to(@factlink, :notice => 'Factlink was successfully updated.') }
#         format.xml  { head :ok }
#       else
#         format.html { render :action => "edit" }
#         format.xml  { render :xml => @factlink.errors, :status => :unprocessable_entity }
#       end
#     end
#   end
# 
#   # DELETE /factlinks/1
#   # DELETE /factlinks/1.xml
#   def destroy
#     @factlink = Factlink.find(params[:id])
#     @factlink.destroy
# 
#     respond_to do |format|
#       format.html { redirect_to(factlinks_url) }
#       format.xml  { head :ok }
#     end
#   end


end