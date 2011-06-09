module FactlinkSubsHelper
  
  def factlink_sub_partial(factlink_sub)
    render :partial => 'factlink_subs/sub', :locals => { :factlink_sub => factlink_sub }
  end
end
