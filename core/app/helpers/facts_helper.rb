module FactsHelper

  def evidence_buttons_locals(fact_relation, user)
    locals = {  :fact_relation => fact_relation,}
    locals[:negative_active] = ''
    locals[:positive_active] = ''
    if current_user.graph_user.opinion_on(fact_relation) == :believes
      locals[:positive_active] = ' active'
    elsif current_user.graph_user.opinion_on(fact_relation) == :disbelieves
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
      return '<img src="#{path}">'.html_safe
    end
  end

end
