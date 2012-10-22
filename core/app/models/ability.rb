class Ability
  class AdminArea;end
  class FactlinkWebapp;end

  include CanCan::Ability

  def user
    @user
  end

  def initialize(user=nil)
    @user=user

    # Anonymous user
    can :get_fact_count, Site
    can :new, Fact

    can :show, String do |template|
      ! /^home\/pages\/help/.match template
    end

    # Registered user
    if user

      if user.agrees_tos
        can :access, FactlinkWebapp
        define_channel_abilities
        define_topic_abilites
        define_fact_abilities
        define_fact_relation_abilities
        define_user_abilities
        define_user_activities_abilities
        define_topic_abilities

        can :show, String
      else
        cannot :manage, :all
        can :sign_tos, user
        can :read, user
      end

      can :read_tos, user
    end
    define_feature_toggles
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

  def define_topic_abilites
    if user
      can :index, Topic
    end
  end

  def define_fact_abilities
    can :index, Fact
    can :read, Fact
    can :get_evidence, Fact
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
      can :destroy, FactRelation do |f|
        f.created_by == user.graph_user && f.deletable?
      end
    end
  end

  def define_user_abilities
    if user
      can :update, user
      can :read, User do
        |u| not u.hidden
      end

      if user.admin?
        can :access, AdminArea
        can :manage, User
        can :approve, User
        cannot :sign_tos, User
      end
      if user.has_invitations_left?
        can :invite, User
      else
        cannot :invite, User
      end
    end
  end

  def define_user_activities_abilities
    if user
      can :index, Activity
      can :mark_activities_as_read, User do |u|
        u.id == user.id
      end
      can :see_activities, User do |u|
        u.id == user.id
      end
    end
  end

  def define_topic_abilities
    can :show, Topic
  end

  FEATURES = %w(pink_feedback_button authority_calculation_details notification_settings social_connect firefox_extension messaging)
  GLOBAL_ENABLED_FEATURES = [:firefox_extension]

  def enable_features list
    @features ||= []
    list.each do |feature|
      can :"see_feature_#{feature}", FactlinkWebapp
      @features << feature.to_s
    end
  end

  def define_feature_toggles
    if user
      enable_features [:version_number]  if user.admin?
      enable_features [:beginners_hints] if (user.sign_in_count || 0) < 10
      enable_features user.features
      enable_features GLOBAL_ENABLED_FEATURES
    end
  end

  def feature_toggles
    return @features
  end

end
