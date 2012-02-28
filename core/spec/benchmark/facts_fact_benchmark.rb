require 'spec_helper'

describe  do
  it "the speed of the Facts::Fact view" do
    u1 = create :user
    gu1 = u1.graph_user

    u2 = create :user
    gu2 = u2.graph_user

    u3 = create :user
    gu3 = u3.graph_user

    u4 = create :user
    gu4 = u4.graph_user

    u5 = create :user
    gu5 = u5.graph_user
    
    current_user = create :user
    current_graph_user = current_user.graph_user
    
  
    f1 = create :fact, created_by: gu1
    f2 = create :fact, created_by: current_graph_user
    
    
    facts = [f1,f2]
    
    view = mock()
    view.stub(
      user_signed_in?: true,
      current_user: current_user,
      current_graph_user: current_graph_user,
      image_tag: "<img/>",
      evidence_search_fact_path: '',
      params: {},
      link_to: '',
      h: '',
      t: '',
      user_profile_path: '',
    )
     
    Benchmark.bmbm do |bm|
      bm.report { foo = facts.map {|f| Facts::Fact.for(fact: f, view: view)}.to_json }
    end
  end
end