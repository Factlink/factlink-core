require 'spec_helper'

describe "admin/jobs/index" do
  before do
    assign(:jobs, [
      stub_model(Job,
        :title => "Title",
        :content => "MyText"
      ),
      stub_model(Job,
        :title => "Title",
        :content => "MyText"
      )
    ])
  end

  it "renders a list of jobs" do
    render
  end
end

