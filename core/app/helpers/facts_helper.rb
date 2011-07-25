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

  # Popups
  def potential_childs_popup(potential_childs)
    render :partial => 'facts/client_popups/potential_childs', 
              :locals => { :potential_childs => potential_childs }
  end

  def potential_parents_popup(potential_parents)
    render :partial => 'facts/client_popups/potential_parents', 
              :locals => { :potential_parents => potential_parents }
  end


  # Listitem for in factlink client overview
  def factlink_source_partial_as_li(fact_relation)    
    render :partial => 'facts/partial/source_as_li', 
              :locals => { :fact_relation => fact_relation }
  end
  
  def evidence_as_li(fact, evidence)
    render :partial => 'facts/partial/add_evidence_as_li', 
              :locals => { :fact => fact, :evidence => evidence }
  end
  
  # Score block of the top factlink in client
  def factlink_score_partial(fact)
    render :partial => 'facts/partial/bar_chart', 
              :locals => { :fact => fact }
  end


  # The vote options for a fact: believe, doubt, disbelieve
  deprecate
  def opinion_options(fact)
    render :partial => 'facts/partial/opinion_options', 
              :locals => { :fact => fact }
  end


  # Shows opinion of user on this fact.
  # Links to toggle the opinion.
  def fact_opinion_options(fact_relation)
    render :partial => 'facts/partial/opinion_options',
              :locals => { :fact_relation => fact_relation }
  end

  # Shows the opinion on this FactRelation
  # Links to toggle the believe on the relation.
  def fact_relation_relevance_options(fact_relation)
    render :partial => 'facts/partial/relevance_options', 
              :locals => { :fact_relation => fact_relation }
  end
  
  def no_facts_have_been_added_as_li
    render :partial => 'facts/partial/no_facts_added_message'
  end
  
  # Percentage and brain cycles in <li>
  def fl_source_stats(fact_relation)
    render  :partial  => 'facts/partial/fl_source_stats',
            :locals   => { :fact_relation => fact_relation }
  end

  deprecate
  def relevance_class_on_fact(type, fact)
    current_user.active_class_for_type_and_fact(type, fact)
  end
  
  def active_class_for_type_and_fact(type, fact)
    if current_user.opinion_on_fact_for_type?(type, fact)
      return " class='active'"
    end
  end

end