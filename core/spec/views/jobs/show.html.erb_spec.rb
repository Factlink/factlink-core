require 'spec_helper'

describe "jobs/show.html.erb" do
  before(:each) do
    assign(:job, stub_model(Job,
      :title       => "Title",
      :content     => "MyText",
      :show        => true
    ))

    assign(:jobs, [
      stub_model(Job,
        :title   => "Title",
        :content => "MyText"
      ),
      stub_model(Job,
        :title   => "Title",
        :content => "MyText"
      )
    ])
    view.stub(:can?) { false }
  end

  it "renders a job" do
    render
  end


end
