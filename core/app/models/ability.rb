class Ability
  include CanCan::Ability

  def user
    @user
  end

  def initialize(user=nil)
    @user=user

    define_channel_abilities
    define_fact_abilities
    define_fact_relation_abilities
    define_user_abilities
  end

  def define_channel_abilities
    if user
      can :index, Channel
      can :read, Channel
      can :manage, Channel do |ch|
        ch.created_by == user.graph_user
      end
    end
  end
  
  def define_fact_abilities
    can :index, Fact
    can :read, Fact
    if user
      can :opinionate, Fact
      can :add_evidence, Fact
      can :manage, Fact do |f|
        f.created_by == user.graph_user
      end
    end
  end
  
  def define_fact_relation_abilities
    if user
      can :opinionate, FactRelation
    end
  end
  
  def define_user_abilities
    can :read, Job

    if user
      can :update, user
      
      if user.admin?
        can :manage, User
        can :manage, Job
      end
    end
  end
  
end