module FactlinksHelper

  # Listitem for in factlink client overview
  def factlink_source_partial_as_li(factlink, parent)
    render :partial => 'factlinks/source_as_li', :locals => { :factlink => factlink, :parent => parent }
  end
  
  # Score block of the top factlink in client
  def factlink_score_partial(factlink)
    render :partial => 'factlinks/score', :locals => { :factlink => factlink }
  end

  # The vote options for a fact: believe, doubt, disbelieve
  def vote_options(factlink, parent)
    render :partial => 'factlinks/vote_options', :locals => { :factlink => factlink, :parent => parent }
  end

end
