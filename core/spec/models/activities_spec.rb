require 'spec_helper'

describe Activity do
  before do
    @f1 = FactoryGirl.create(:fact)
    @f2 = FactoryGirl.create(:fact)
    @ch = FactoryGirl.create(:channel)
    @gu = FactoryGirl.create(:user).graph_user
  end
  
  it do
    @a = Activity.create(
           :user => @gu,
           :action => :foo,
           :subject => @f1,
           :object => @f2
         )
    @a = Activity[@a.id]
    @a.user.should == @gu
    @a.subject.should == @f1
    @a.object.should == @f2
  end
  
  it do
    @a = Activity.create(
           :user => @gu,
           :action => :foo,
           :subject => @f1,
           :object => @ch
         )
    @a = Activity[@a.id]
    @a.user.should == @gu
    @a.subject.should == @f1
    @a.object.should == @ch
  end
  
end