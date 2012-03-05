require 'spec_helper'

describe FactlinkApi::UserManager do
  it "should create a user with the right arguments" do
    time = DateTime.now
    DateTime.stub!(now: time)
    FactlinkApi::UserManager.create_user "Gerard", "gelefiets@hotmail.com", "god1337"
    @u = User.where(username: "Gerard").first
    @u.encrypted_password.should == 'god1337'
    @u.email.should == 'gelefiets@hotmail.com'
    @u.confirmed_at.to_i.should == time.to_i
  end
end