require 'spec_helper'


describe Facts::Fact do

  let(:user) { create :user }

  let(:view) do
    view = mock('view')
    view.should_receive(:current_user).any_number_of_times.and_return(user)
    view.should_receive(:lookup_context).any_number_of_times.and_return(nil)
    view
  end

  let(:fact) {create :fact}

  subject {
    Facts::Fact.for(fact: fact, view: view)
  }

  describe :modal? do
    pending "should work" do
      subject.modal?.should == false
    end
  end
end