class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    unless user.new?
      can :update, user
      can :index, Channel
      can :read, Channel
      can :manage, Channel do |ch|
        ch.created_by == user.graph_user
      end
    end
  end
end
