module FactlinksHelper

  def factlink_source_partial_as_li(factlink)
    render :partial => 'factlinks/source_as_li', :locals => { :factlink => factlink }
  end

end
