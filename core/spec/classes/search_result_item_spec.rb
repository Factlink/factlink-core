require File.expand_path('../../../app/classes/search_result_item.rb', __FILE__)

describe SearchResultItem do

  let(:obj1) { String }
  subject {SearchResultItem.new klass: obj1.class, obj: obj1 }

  it { subject.klass.should == obj1.class }
  it { subject.obj.should == obj1 }

end