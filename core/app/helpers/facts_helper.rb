module FactsHelper

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


  def evidence_buttons(fact_relation, user)
    locals = evidence_buttons_locals(fact_relation,user)
    if fact_relation.type.to_sym == :supporting 
      locals[:positive_action] = "supporting"
      locals[:negative_action] = "not supporting"
    elsif fact_relation.type.to_sym == :weakening
      locals[:positive_action] = "weakening"
      locals[:negative_action] = "not weakening"
    end
    render "/facts/evidence_buttons",  locals
  end
  
  class SemiMustacheView
    include Rails.application.routes.url_helpers    
    include ActionView::Helpers::UrlHelper
    def controller
      return nil.andand #dit is mijn ranzigste truc ooit -- mark
    end
    def user_signed_in?
      return @current_user
    end
    def image_tag(path)
      return "<img src='#{path}'>".html_safe
    end
  end
  
  class FactView < SemiMustacheView

    def initialize(fact,user,channel)
      @fact = fact
      @current_user = user
      @channel = channel
    end
    
    
    def no_evidence_message
      if user_signed_in?
        "Perhaps you know something that supports or weakens this fact?"
      else
        "There are no Factlinks supporting or weakening this Factlink at the moment."
      end
    end

    
    def deletable_from_channel?
      user_signed_in? and @channel and @channel.editable? and @channel.created_by == @current_user.graph_user
    end
    
    def remove_from_channel_path
      remove_fact_from_channel_path(@current_user.username, @channel.id, @fact.id)
    end
  end
  

      
end
