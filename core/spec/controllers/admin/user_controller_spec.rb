require 'spec_helper'

describe Admin::UsersController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      username: "test_user",
      first_name: "Test",
      last_name: "User",
      email: "test@mail.nl",
      password: "test123",
      password_confirmation: "test123"
    }
  end

  let (:user)  {create :full_user, :admin}

  before do
    should_check_admin_ability

    @user1 = create :user
    @user2 = create :user
  end

  describe "GET index" do
    it "should render the index" do
      authenticate_user!(user)
      should_check_can :index, User
      get :index
      response.should be_success
    end
  end

  describe "GET suspended" do
    it "should render the suspended users" do
      authenticate_user!(user)
      should_check_can :suspended, User
      get :suspended
      response.should be_success
    end
  end


  describe "GET reserved" do
    it "should render the reserved" do
      authenticate_user!(user)
      should_check_can :reserved, User
      get :reserved
      response.should be_success
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do

      authenticate_user!(user)
      should_check_can :show, @user1

      get :show, {:id => @user1.id}
      response.should be_success
      assigns(:user).should eq(@user1)
    end
  end

  describe "PUT /approved" do
    it "should set approved" do
      put :approve, id: @user1.id, format: 'json'
      response.should_not be_succes
    end
  end
end
