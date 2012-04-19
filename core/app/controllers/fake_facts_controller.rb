class FakeFactsController < ApplicationController
  layout "fake_facts"

  def facts
    [
      "Bananen zijn krom",
      "Linealen zijn recht"
    ]
  end

  def show
    type = params[:cid].to_i
    factnr = params[:f].to_i

    if params[:p].to_i.modulo(2) == 0
      beltype = :disbelieve
    else
      beltype = :believe
    end

    pos_opinions = [1,0,0]
    neg_opinions = [0,0,1]

    if type == 0 # no opinions
      interacting_users = []
      pos_opinions = [0,0,0]
      neg_opinions = [0,0,0]
    elsif type == 1 # majority opinions
      interacting_users = []
      pos_opinions = [340,10,30]
      neg_opinions = [34,10,303]
    elsif type == 2
      interacting_users = [["fam expert","https://secure.gravatar.com/avatar/2fbbe1c53162b9e2417bb85aab1726a1?rating=PG&size=20&default=retro", beltype]]
    elsif type == 3
      interacting_users = [["unfam expert","https://secure.gravatar.com/avatar/2fbbe1c53162b9e2417bb85aab1726a1?rating=PG&size=20&default=retro", beltype ]]
    elsif type == 4
      interacting_users = [["fam non-expert","https://secure.gravatar.com/avatar/2fbbe1c53162b9e2417bb85aab1726a1?rating=PG&size=20&default=retro", beltype]]
    elsif type == 5
      interacting_users = [["unfam nonexp","https://secure.gravatar.com/avatar/2fbbe1c53162b9e2417bb85aab1726a1?rating=PG&size=20&default=retro", beltype]]
    else
      interacting_users = []
    end

    if params[:p].to_i.modulo(2) == 0
      opinions = neg_opinions
    else
      opinions = pos_opinions
    end

    @fact = FakeFact.new opinions, interacting_users, facts[factnr]
    render "facts/extended_show"
  end

end