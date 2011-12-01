require 'spec_helper'


describe "beliefs should work as described in the google doc" do
  include BeliefExpressions

  let(:u1) {FactoryGirl.create(:graph_user)}
  let(:u2) {FactoryGirl.create(:graph_user)}
  let(:u3) {FactoryGirl.create(:graph_user)}
  let(:u4) {FactoryGirl.create(:graph_user)}

  let(:f1) {FactoryGirl.create(:fact)}
  let(:f2) {FactoryGirl.create(:fact)}

  # f1 --> f2
  let(:f22) { f2.add_evidence(:supporting,f1,u1) }
  
  # f1 !-> f2
  let(:f23) { f2.add_evidence(:weakening,f1,u1) }

  it "scenario 0" do
    opinion?(f1) == _(0.0,0.0,1.0,0.0)
  end

  it "scenario 1" do
    b(u1,f1)
    b(u2,f1)
    opinion?(f1) == _(1.0,0.0,0.0,2.0)
  end

  it "scenario 2" do
    b(u1,f1)
    d(u2,f1)
    opinion?(f1) == _(0.5,0.5,0.0,2.0)
  end

  it "scenario 3" do
    b(u1,f1)
    u(u2,f1)
    opinion?(f1) == _(0.5,0.0,0.5,2.0)
  end

  it "scenario 4" do
    b(u1,f1)
    b(u2,f1)
    b(u2,f22)
    opinion?(f22) == _(1.0,0.0,0.0,1.0)
    opinion?(f2) == _(1.0,0.0,0.0,1.0)
  end

  it "scenario 5" do
    b(u1,f1)
    b(u2,f1)
    b(u2,f23)
    opinion?(f23) == _(1.0,0.0,0.0,1.0)
    opinion?(f2) == _(0.0,1.0,0.0,1.0)
  end
  
  it "scenario 6" do
    b(u1,f1)
    b(u2,f1)
    b(u1,f22)
    d(u2,f22)
    opinion?(f22) == _(0.5,0.5,0.0,2.0)
    opinion?(f2) == _(0.5,0.0,0.5,2.0)
  end
  
  it "scenario 7" do
    b(u1,f1)
    d(u2,f1)
    b(u1,f22)
    opinion?(f1) == _(0.5,0.5,0.0,2.0)
    opinion?(f22) == _(1.0,0.0,0.0,1.0)
    opinion?(f2) == _(0.5,0.0,0.5,1.0)
  end
  
  it "scenario 8" do
    b(u1,f1)
    b(u2,f1)
    b(u1,f22)
    d(u3,f2)
    opinion?(f1) == _(1.0,0.0,0.0,2.0)
    opinion?(f22) == _(1.0,0.0,0.0,1.0)
    opinion?(f2) == _(0.5,0.5,0.0,2.0)
  end
  
  
  
  describe "Authorities" do
    before do
    
      @f1 = FactoryGirl.create(:fact)
      @f1.created_by = u1.graph_user
      @f1.save
    
      @f2 = FactoryGirl.create(:fact, :created_by => u2.graph_user)
      @f3 = FactoryGirl.create(:fact, :created_by => u3.graph_user)

      @f4 = FactoryGirl.create(:fact)
      @f4.created_by = u1.graph_user
      @f4.save

      @f5 = FactoryGirl.create(:fact)
      @f6 = FactoryGirl.create(:fact)
    end
  
    # Scenario A (a user without any history in Factlink):
    # a(U1) = 1
    it "for a user without history in Factlink the authority should be 1.0" do
      a(u1) == 1.0
    end
  
    # Scenario B (a user that has only believed one fact):
    # b(U1, F1)
    # a(U1) = 1
    # Should have no impact in demo version
    it "for a user that believes one fact the authority should be 1.0" do
      @f1 = FactoryGirl.create(:fact)
      b(u1, @f1)
      a(u1) == 1.0
    end
  
  
    # Scenario C (a user has created only one fact):
    # c(U1, F1)
    # a(U1) = 1
    # Should have no impact
    it "should be 1.0 when a user has create one fact" do    
      a(u1) == 1.0
    end
  
    # Scenario D (a user has created only one fact. Another user has believed the fact):
    # c(U1, F1)
    # b(U2, F1)
    # a(U1) = 1
    it "should be 1.0 when another user believes a fact created by the user" do
      b(u2, @f1)
      a(u1) == 1.0
    end
  
    # Scenario E (a user has created only one fact. The fact is used to support another fact):
    # c(U1, F1)
    # F22 = (F1 -> F2)
    # a(U1) = 1
    it "should have ana authority of 1.0 when user created one fact" do
      @f2.add_evidence(:supporting, @f1, u1)
      a(u1) == 1.0
    end
  
    # Scenario F (a user has created a fact that is used multiple times):
    # c(U1, F1)
    # F22 = (F1 -> F2)
    # c(U2, F22)
    # F23 = (F1 -> F3)
    # c(U2, F23)
    # a(U1) = 2
    it "should have a higher authority when a fact is used multiple times" do
      # @f1 is created bu @gu1
      @f2.add_evidence(:supporting, @f1, u2)
      @f3.add_evidence(:supporting, @f1, u2)
    
      @f2.supporting_facts =~ [@f1]
      @f3.supporting_facts =~ [@f1]
    
      a(u1) == 2
    end
  
    # Scenario G (a user has created multiple facts that are used multiple times):
    # c(U1, F1)
    # F22 = (F1 -> F2)
    # c(U2, F22)
    # F23 = (F1 -> F3)
    # c(U2, F23)
    # c(U1, F4)
    # F42 = (F4 -> F5)
    # c(U2, F42)
    # F43 = (F4 -> F6)
    # c(U2, F43)
    # a(U1) = 3
    # 
    # a(U1) = 1 + log(2) + log(2) = 3
    it "should have an auhority of3 when 2 facts are used twice" do
      @f2.add_evidence(:supporting, @f1, u2)
      @f3.add_evidence(:supporting, @f1, u2)
    
      @f5.add_evidence(:supporting, @f4, u2)
      @f6.add_evidence(:supporting, @f4, u2)
    
      a(u1) == 3
    end
  
    # Scenario H (a user has created multiple facts that are used multiple times, self generated links don’t count):
    # c(U1, F1)
    # F22 = (F1 -> F2)
    # c(U1, F22)
    # F23 = (F1 -> F3)
    # c(U2, F23)
    # c(U1, F4)
    # F42 = (F4 -> F5)
    # c(U1, F42)
    # F43 = (F4 -> F6)
    # c(U2, F43)
    # a(U1) = 1
    # 
    # a(U1) = 1 + log(1) + log(1) = 1
    it "should count self generated links" do
      # By the user himself
      @f2.add_evidence(:supporting, @f1, u1)

      # By another user
      @f3.add_evidence(:supporting, @f1, u2)
    
      # By the user himself
      @f5.add_evidence(:supporting, @f4, u1)

      # By another user
      @f6.add_evidence(:supporting, @f4, u2)
    
      a(u1) == 1.0
    end
  
    # Scenario I (a user has created multiple facts that are used multiple times):
    # c(U1, F1)
    # F22 = (F1 -> F2)
    # c(U2, F22)
    # F23 = (F1 -> F3)
    # c(U2, F23)
    # c(U1, F4)
    # F42 = (F4 -> F5)
    # c(U2, F42)
    # F43 = (F4 -> F6)
    # c(U2, F43)
    # a(U1) = 3
    # 
    # a(U1) = 1 + log(2) + log(2) = 3
    it "should have an auhority of 3 when 2 facts are used for support and two for weakening" do
      @f2.add_evidence(:supporting, @f1, u2)
      @f3.add_evidence(:supporting, @f1, u2)
    
      @f5.add_evidence(:weakening, @f4, u2)
      @f6.add_evidence(:weakening, @f4, u2)

      a(u1) == 3
    end
  end
end
