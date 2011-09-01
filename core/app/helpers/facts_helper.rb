module FactsHelper
  include Canivete::Deprecate

  # Sorting results on search page
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"

    link_to title, {  :s => params[:s], 
                      :sort => column, 
                      :direction => direction
                    }, 
                    { :class => css_class }
  end

  def fact_listing(facts)
    render :partial => "home/snippets/fact_listing", 
                :locals => {  :facts => facts }
  end

  def fact_snippet(fact,channel=nil)
    render :partial => "/facts/partial/fact_container", 
	            :locals => {  :fact => fact, :channel => channel }
  end
  
  def fact_bubble(fact,add_to_fact=nil) 
    render :partial => "/facts/partial/fact_bubble", 
	            :locals => {  :fact => fact,
	                          :add_to_fact => add_to_fact,
	                          :fact_relation => nil }
  end
  
  def fact_interacting_users(opinions)
    render :partial => "/facts/partial/users_popup",
              :locals => {:opinion => opinions.to_a }
  end

end