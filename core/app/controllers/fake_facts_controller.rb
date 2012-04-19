class FakeFactsController < ApplicationController
  layout "fake_facts"

  def show
    type = params[:cid].to_i
    if type == 0
      interacting_users = []

      opinions = {
        believes: 0,
        disbelieves: 0,
        doubts: 0
      }
    elsif type == 2
      interacting_users = [
        ["remon", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"],
        ["tom", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"]
      ]

      opinions = {
        believes: 100,
        disbelieves: 5,
        doubts: 10
      }
    else
      interacting_users = [
        ["remon", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"],
        ["remon", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"],
        ["tom", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"]
      ]

      opinions = {
        believes: 100,
        disbelieves: 5,
        doubts: 10
      }
    end

    @fact = FakeFact.new opinions, interacting_users, "Bananen zijn krom"
    render "facts/extended_show"
  end

end