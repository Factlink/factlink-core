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


  def self.new ops, interacting_users, factlink_text
    opinions = {
      believes: ops[0],
      doubts: ops[1],
      disbelieves: ops[2]
    }
    interactions = interacting_users.map { |u|
      gu = fake_graph_user u[0], u[1]
      fake_interaction(gu, u[2])
    }
    
    x = Hashie::Mash.new({
      data: {
        title: "",
        displaystring: factlink_text,
        created_at: DateTime.now
      },
      id: 1,
      interactions: {  below: interactions },

      mash_believes_count: opinions[:believes],
      mash_disbelieves_count: opinions[:disbelieves],
      mash_doubts_count: opinions[:doubts],

      supporting_facts: [],
      weakening_facts: [],
      created_by: {user: {username: 'hoi'}},
      get_opinion: fake_wheel(opinions[:believes], opinions[:disbelieves], opinions[:doubts])
    })

    x.singleton_class.send :include, Foo

    x
  end

  def self.fake_interaction user, action
    @i ||= 0
    @i = @i + 1
    { 
      user: user,
      user_id: user[:user][:graph_user][:id],
      action: action.to_s,
      id: @i
    }
  end

  def self.fake_graph_user username, avatar
    @id ||=0
    @id = @id + 1
    {
      user: {
        graph_user: {
          id: @id,
          editable_channels_by_authority: [],
        },
        username: username,
        avatar_url: avatar
      }
    }
  end

  def self.fake_wheel  believes, disbelieves, doubts
    total_opinions = doubts + disbelieves + believes
    o = Opinion.tuple(believes, disbelieves, doubts, total_opinions)
    return o
  end
end