class ResetAllSearchIndices
  def self.perform
    fail "when using this again please check that it works first"
    # this is code which is only ever used in migrations
    # it's not very well under test, and since we don't use it now,
    # we postpone this to a moment when (if?) we actually need this

    ElasticSearch.truncate

    FactData.all.each(&:update_search_index)
    User.all.each(&:update_search_index)
  end
end
