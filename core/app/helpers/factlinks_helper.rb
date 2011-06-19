module FactlinksHelper

  # Sorting results on search page
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:s => params[:s], :sort => column, :direction => direction}, {:class => css_class}
  end

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
