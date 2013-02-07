class Ability
  class AdminArea;end
  class FactlinkWebapp;end

  include CanCan::Ability

  def user
    @user
  end

  def signed_in?
    user and not user.features.include? :act_as_non_signed_in
  end

  def user_acting_as_non_signed_in
    user and user.features.include? :act_as_non_signed_in
  end

  def agrees_tos?
    signed_in? and user.agrees_tos
  end

  def initialize(user=nil)
    @user=user

    # Anonymous user
    can :get_fact_count, Site
    can :new, Fact

    can :show, String do |template|
      ! /^home\/pages\/help/.match template
    end

    if agrees_tos?
      can :access, FactlinkWebapp
      can :show, String
    end

    define_channel_abilities
    define_topic_abilites
    define_fact_abilities
    define_fact_relation_abilities
    define_user_abilities
    define_user_activities_abilities
    define_topic_abilities
    define_tos_abilities
    define_feature_toggles
  end

  def define_channel_abilities
    if agrees_tos?
      can :index, Channel
      can :read, Channel
      can :manage, Channel do |ch|
        ch.created_by_id == user.graph_user_id
      end
    end
  end

  def define_topic_abilites
    if agrees_tos?
      can :index, Topic
    end
  end

  def define_fact_abilities
    if agrees_tos?
      can :index, Fact
      can :read, Fact
      can :opinionate, Fact
      can :add_evidence, Fact
      can :manage, Fact do |f|
        f.created_by_id == user.graph_user_id
      end
    elsif user_acting_as_non_signed_in
      can :index, Fact
      can :read, Fact
    end
  end

  def define_fact_relation_abilities
    if agrees_tos?
      can :opinionate, FactRelation
      can :destroy, FactRelation do |fr|
        fr.created_by_id == user.graph_user_id && fr.deletable?
      end
    end
  end

  def define_user_abilities
    if agrees_tos?
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
    if agrees_tos?
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

  def define_tos_abilities
    can :read_tos, user
    unless agrees_tos?
      can :sign_tos, user
      can :read, user
    end
  end

  FEATURES = %w(pink_feedback_button authority_calculation_details skip_create_first_factlink topic_facts memory_profiling act_as_non_signed_in)
  GLOBAL_ENABLED_FEATURES = []

  def enable_features list
    list.each do |feature|
      can :"see_feature_#{feature}", FactlinkWebapp
      @features << feature.to_s
    end
  end

  def define_feature_toggles
    @features ||= []
    if agrees_tos?
      enable_features [:beginners_hints] if (user.sign_in_count || 0) < 10
      enable_features user.features
      enable_features GLOBAL_ENABLED_FEATURES
    end
  end

  def feature_toggles
    return @features
  end

end
