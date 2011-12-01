class Ability
  include CanCan::Ability

  def user
    @user
  end

  def initialize(user)
    @user=user
    
    unless user.new?
      can :update, user
      define_channel_abilities
      define_fact_abilities
    end
    
  end

  def define_channel_abilities
    can :index, Channel
    can :read, Channel
    can :manage, Channel do |ch|
      ch.created_by == user.graph_user
    end
  end
  
  def define_fact_abilities
    can :index, Fact
    can :read, Fact
    can :opinionate, Fact
    
    can :manage, Fact do |f|
     f.created_by == user.graph_user
    end
  end
  

end
