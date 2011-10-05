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

  deprecate
  def fact_snippet(fact,channel=nil,modal=nil)
    render :partial => "/facts/fact", 
	            :locals => {  :fact => fact, :channel => channel, :modal => modal }
  end
  
  def proxy_scroll_url(fact)
    return FactlinkUI::Application.config.proxy_url + "?url=" + URI.escape(fact.site.url) + "&scrollto=" + URI.escape(fact.id)
  end

  def editable_title(fact)
    if user_signed_in? and (fact.created_by == current_user.graph_user)
      return " edit"
    else
      return ""
    end 
  end
  
  def show_evidence(bool)
    unless bool
      return 'style="display: none"'.html_safe
    end
  end

  def evidence_buttons_locals(fact_relation, user)
    locals = {  :fact_relation => fact_relation,}
    locals[:negative_active] = ''
    locals[:positive_active] = ''
    if current_user.graph_user.opinion_on(fact_relation) == :beliefs
      locals[:positive_active] = ' active'
    elsif current_user.graph_user.opinion_on(fact_relation) == :disbeliefs
      locals[:negative_active] = ' active'
    end
    locals
  end

  def evidenced_buttons(fact_relation, user)
    locals = evidence_buttons_locals(fact_relation,user)
    if fact_relation.type.to_sym == :supporting 
      locals[:positive_action] = "Supported by"
      locals[:negative_action] = "Not supported by"
    elsif fact_relation.type.to_sym == :weakening
      locals[:positive_action] = "Weakened by"
      locals[:negative_action] = "Not weakened by"
    end
    render :partial => "/facts/partial/evidence_buttons", 
	            :locals => locals
  end

  def evidence_buttons(fact_relation, user)
    locals = evidence_buttons_locals(fact_relation,user)
    if fact_relation.type.to_sym == :supporting 
      locals[:positive_action] = "Supporting"
      locals[:negative_action] = "Not supporting"
    elsif fact_relation.type.to_sym == :weakening
      locals[:positive_action] = "Weakening"
      locals[:negative_action] = "Not weakening"
    end
    render :partial => "/facts/partial/evidence_buttons", 
	            :locals => locals
  end
end
