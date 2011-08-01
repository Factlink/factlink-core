def fact(fact_string,url="http://example.org/")
  f = Fact.by_display_string(fact_string)
  if not f
    f = Fact.new
    f.displaystring = fact_string
    f.url = url
    f.created_by = User.all.first.graph_user
    f.save
  end
  f
end

def fact_relation(fact1,relation,fact2)
  f1 = fact(fact1)
  f2 = fact(fact2)
  user = User.all.first
  f2.add_evidence(relation,f1,user)
end