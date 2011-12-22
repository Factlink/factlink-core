require 'spec_helper'

describe "jobs/show.html.erb" do
  before(:each) do
    @job = assign(:job, stub_model(Job,
      :title => "Title",
      :content => "MyText"
    ))
  end


end
