require 'spec_helper'

def others(opinion)
  others = [:believes, :doubts, :disbelieves]
  others.delete(opinion)
  others
end

def user_fact_opinion(user, opinion, fact)
  authority = Authority.on(fact, for: user).to_f + 1
  Opinion.for_type(opinion,authority)
end

def opinions
  [:believes, :doubts, :disbelieves]
end

describe Believable do

  subject(:believable) { Believable.new Nest.new('gerrit') }

  let(:user)  {create(:graph_user)}
  let(:user2) {create(:graph_user)}

  context "initially" do
    opinions.each do |opinion|
      it { believable.opiniated(opinion).count.should == 0 }
      it { believable.opiniated(opinion).all.should == [] }
    end
  end


  opinions.each do |opinion|

    context "after 1 person has stated its #{opinion}" do
      it do
        believable.add_opiniated(opinion, user)

        believable.opiniated(opinion).count.should == 1
       end
    end

    context "after 1 person has stated its #{opinion} twice" do
      it do
        believable.add_opiniated(opinion, user)
        believable.add_opiniated(opinion, user)

        believable.opiniated(opinion).count.should == 1
      end
    end


    context "after one person who #{opinion} is added and deleted" do
      it do
        believable.add_opiniated(opinion, user)
        believable.remove_opinionateds user

        believable.opiniated(opinion).count.should == 0
      end
    end

    context "after two believers are added" do
      it do
        believable.add_opiniated(opinion, user)
        believable.add_opiniated(opinion, user2)

        believable.opiniated(opinion).count.should == 2
      end
    end

    others(opinion).each do |other_opinion|
      context "when two persons start with #{opinion}, after person changes its opinion from #{opinion} to #{other_opinion}" do
        it do
          believable.add_opiniated(opinion, user)
          believable.add_opiniated(opinion, user2)

          believable.add_opiniated(other_opinion, user)

          believable.opiniated(opinion).count.should == 1
        end
      end

      context "when two persons start with #{opinion}, after both existing believers change their opinion from #{opinion} to #{other_opinion}" do
        it do
          believable.add_opiniated(opinion, user)
          believable.add_opiniated(opinion, user2)

          believable.add_opiniated(other_opinion, user)
          believable.add_opiniated(other_opinion, user2)

          believable.opiniated(opinion).count.should == 0
        end
      end
    end

  end
end
