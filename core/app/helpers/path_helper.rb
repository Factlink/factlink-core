module PathHelper
  def fast_remove_fact_from_channel_path(username, channel_id, fact_id)
    "/#{username}/channels/#{channel_id}/facts/#{fact_id}"
  end
end
