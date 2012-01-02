class RelatedUsersCalculator
  def related_users(facts, options={})
    limit = options[:limit] || 5
    without = options[:without] || []
    users = facts.map{|fact| fact.opinionated_users}.reduce(:|).andand.sort_by(:cached_authority, :order => "DESC", :limit => limit)
    users ||= []
    users.delete_if {|gu| without.include? gu}
  end
end