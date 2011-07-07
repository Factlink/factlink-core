require 'spec_helper'

describe FactRelation do

  before(:each) do
    @parent = Fact.new
    @factlink = Fact.new
    @factlink2 = Fact.new
    
    @user1 = User.new(:username => "tomdev")
    @user2 = User.new(:username => "zamboya")
  end
end