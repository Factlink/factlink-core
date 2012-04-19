class FakeFactsController < ApplicationController
  layout "fake_facts"

  def show
    if params[:type] == 1
      @interacting_users_aaa = []

      @opinions_aaa = {
        believes: 100,
        disbelieves: 5,
        doubts: 10
      }
    elsif params[:type] == 2
      @interacting_users_aaa = [
        ["remon", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"],
        ["tom", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"]
      ]

      @opinions_aaa = {
        believes: 100,
        disbelieves: 5,
        doubts: 10
      }
    else
      @interacting_users_aaa = [
        ["remon", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"],
        ["tom", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"]
      ]

      @opinions_aaa = {
        believes: 100,
        disbelieves: 5,
        doubts: 10
      }
    end

    @fact = FakeFact.new @opinions_aaa, @interacting_users_aaa, "Bananen zijn krom"
    render "facts/extended_show"
  end

end