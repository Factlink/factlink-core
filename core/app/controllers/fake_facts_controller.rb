class FakeFactsController < ApplicationController
  layout "fake_facts"

  def show
    if params[:type] == 1
      @interacting_users = []

      @opinions = {
        believes: 100,
        disbelieves: 5,
        doubts: 10
      }
    elsif params[:type] == 2
      @interacting_users = [
        fake_user("remon", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"),
        fake_user("tom", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro")
      ]

      @opinions = {
        believes: 100,
        disbelieves: 5,
        doubts: 10
      }
    else
      @interacting_users = [
        fake_user("remon", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro"),
        fake_user("tom", "https://secure.gravatar.com/avatar/cd0ce9385b21c5015f66854e760fdfe2?rating=PG&size=20&default=retro")
      ]

      @opinions = {
        believes: 100,
        disbelieves: 5,
        doubts: 10
      }
    end

    @fact = fake_fact @opinions, @interacting_users, "Bananen zijn krom"

    render "facts/extended_show"
  end

  private
  module Foo
    def opiniated(type)
      count = self[:"mash_#{type}_count"]

      y  =  Object.new

      y.singleton_class.send(:define_method, :count) do
        return count
      end

      y
    end
  end

  def fake_fact opinions, interacting_users, factlink_text
    total_opinions = opinions[:doubts] + opinions[:disbelieves] + opinions[:believes]

    y = interacting_users.map { |interacting_user|
      fake_interaction(interacting_user)
    }

    puts "WHADDAP: #{y}"
    STDOUT.flush

    x = Hashie::Mash.new({
      data: {
        title: "",
        displaystring: factlink_text,
        created_at: DateTime.now
      },
      id: 1,
      interactions: {
        below: interacting_users.map { |interacting_user|
          fake_interaction(interacting_user)
        }
      },

      mash_believes_count: opinions[:believes],
      mash_disbelieves_count: opinions[:disbelieves],
      mash_doubts_count: opinions[:doubts],

      supporting_facts: [],
      weakening_facts: [],
      created_by: GraphUser.first,
      get_opinion: fake_wheel(total_opinions,
                              (opinions[:believes].to_f/total_opinions)*100,
                              (opinions[:disbelieves].to_f/total_opinions)*100,
                              (opinions[:doubts].to_f/total_opinions)*100)
    })

    x.singleton_class.send :include, Foo

    x
  end

  def fake_interaction user
    {
      user: user,
      user_id: Time.now.to_i,
      action: ""
    }
  end

  def fake_user avatar, username
    {
      user: {
        graph_user: {
          id: 1,
          editable_channels_by_authority: [],
        },
        username: avatar,
        avatar_url: username
      }
    }
  end

  def fake_wheel count, believes, disbelieves, doubt
    {
      as_percentages: {
        authority: count,
        believe: {
          percentage: believes
        },
        disbelieve: {
          percentage: disbelieves
        },
        doubt: {
          percentage: doubt
        }
      }
    }
  end
end