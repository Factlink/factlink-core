require 'logger'

class SearchInteractor
  def initialize keywords, options={}
    raise 'Keywords should be an string.' unless keywords.kind_of? String
    raise 'Keywords must not be empty.'   unless keywords.length > 0

    @keywords = keywords
    @ability = options[:ability]
    @page = options[:page] || 1
    @row_count = options[:row_count] || 20
    @log = Logger.new STDERR
  end

  def authorized?
    @ability.can? :index, Fact
  end

  def execute
    raise CanCan::AccessDenied unless authorized?

    local_keywords_copy = filter_keywords

    if local_keywords_copy.length == 0
      return []
    end

    results = Sunspot.search FactData, User, Topic do
        keywords local_keywords_copy

        paginate :page => @page || 1, :per_page => @row_count
    end

    # TODO: This message gets lost easily in history, what are the options?
    if results.hits.count > results.results.count
      @log.error "SOLR Search index is out of sync, please run 'rake sunspot:index'."
    end

    results = results.results.delete_if do |res|
      (res.class == FactData and FactData.invalid(res)) or
      (res.class == User and (res.nil? or res.hidden))
    end

    results
  end

  def filter_keywords
    @keywords.split(/\s+/).select{|x|x.length > 2}.join(" ")
  end
end
