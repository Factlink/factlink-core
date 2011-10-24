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
      locals[:positive_action] = "supported by"
      locals[:negative_action] = "not supported by"
    elsif fact_relation.type.to_sym == :weakening
      locals[:positive_action] = "weakened by"
      locals[:negative_action] = "not weakened by"
    end
    render :partial => "/facts/partial/evidence_buttons", 
	            :locals => locals
  end

  def evidence_buttons(fact_relation, user)
    locals = evidence_buttons_locals(fact_relation,user)
    if fact_relation.type.to_sym == :supporting 
      locals[:positive_action] = "supporting"
      locals[:negative_action] = "not supporting"
    elsif fact_relation.type.to_sym == :weakening
      locals[:positive_action] = "weakening"
      locals[:negative_action] = "not weakening"
    end
    render :partial => "/facts/partial/evidence_buttons", 
	            :locals => locals
  end
  
  class FactBubbleView
    def initialize(fact,user,channel)
      @fact = fact
      @current_user = user
      @channel = channel
    end
    
    def user_signed_in?
      return @current_user
    end
    
    def no_evidence_message
      if user_signed_in?
        "Perhaps you know something that supports or weakens this fact?"
      else
        "There are no facts supporting or weakening this fact at the moment."
      end
    end

    def no_evidenced_message
      if user_signed_in?
        "Perhaps you know something that is supported or weakened by this fact?"
      else
        "There are no facts that are supported or weakened by this fact at the moment."
      end
    end
    
    def delete_from_channel_link
      if user_signed_in? and @channel and @channel.editable? and @channel.created_by == @current_user.graph_user
        link_to(
          image_tag("client/close-button.png", :class => "close", "style" => "float: right"),
          remove_fact_from_channel_path(@current_user.username, @channel.id, @fact.id),
          :method => :delete,
          :confirm => "Are you sure you want to remove this fact from your channel?", 
          :remote => true)
        
      end
    end
  end
  
end
