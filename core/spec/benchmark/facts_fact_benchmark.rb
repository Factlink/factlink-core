require 'spec_helper'

describe  do
  before do
    load File.expand_path('../../../db/init/20110930joel.rb', __FILE__)
  end

  it "the speed of the Facts::Fact view" do
    current_user = User.all.first
    current_graph_user = current_user.graph_user

    facts = Fact.all.all
    facts = facts + facts + facts + facts + facts + facts + facts + facts + facts + facts + facts + facts +
            facts + facts + facts + facts

    view = mock()
    view.stub(
      user_signed_in?: true,
      current_user: current_user,
      current_graph_user: current_graph_user,
      image_tag: "<img/>",
      evidence_search_fact_path: '',
      params: {},
      link_to: '',
      friendly_fact_path: '',
      h: '',
      t: '',
      user_profile_path: '',
      time_ago_short: '',
    )

    Benchmark.bmbm do |bm|
      bm.report { foo = facts.map {|f| Facts::Fact.new(fact: f, view: view)}.to_json }
    end
  end
end
