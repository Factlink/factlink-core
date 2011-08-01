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

def export_fact(fact)
  "fact \"#{quote_string(fact.displaystring)}\", \"#{fact.site.url}\"\n"
end

def fact_relation(fact1,relation,fact2)
  f1 = fact(fact1)
  f2 = fact(fact2)
  user = User.all.first
  f2.add_evidence(relation,f1,user)
end

def export_fact_relation(fact_relation)
  "fact_relation \"#{quote_string(fact_relation.get_from_fact.displaystring)}\", :#{fact_relation.type.to_sym}, \"#{quote_string(fact_relation.get_to_fact.displaystring)}\"\n"
end

def quote_string(v)
  v.to_s.gsub(/\\/, '\&\&').gsub(/"/, "\\\"")
end