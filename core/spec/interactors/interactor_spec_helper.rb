def should_receive_new_and_execute(klass)
  klass_instance = mock()
  klass.should_receive(:new).and_return(klass_instance)
  klass_instance.should_receive(:execute)
end

def should_receive_new_with_and_receive_execute(klass, *arguments)
  klass_instance = mock()
  klass.should_receive(:new).with(*arguments).and_return(klass_instance)
  klass_instance.should_receive(:execute)
end

def stub_classes *classnames
  classnames.each do |classname|
    stub_const classname, Class.new
  end
end
