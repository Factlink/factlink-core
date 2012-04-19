class FakeFact
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


  def self.new opinions, interacting_users, factlink_text
    interacting_users = interacting_users.map {|u| fake_user u[0], u[1]}
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
      created_by: {user: {username: 'hoi'}},
      get_opinion: fake_wheel(total_opinions,
                              (opinions[:believes].to_f/total_opinions)*100,
                              (opinions[:disbelieves].to_f/total_opinions)*100,
                              (opinions[:doubts].to_f/total_opinions)*100)
    })

    x.singleton_class.send :include, Foo

    x
  end

  def self.fake_interaction user
    @i ||= 0
    @i = @i + 1
    { 
      user: user,
      user_id: @i,
      action: ""
    }
  end

  def self.fake_user username, avatar
    {
      user: {
        graph_user: {
          id: 1,
          editable_channels_by_authority: [],
        },
        username: username,
        avatar_url: avatar
      }
    }
  end

  def self.fake_wheel count, believes, disbelieves, doubt
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