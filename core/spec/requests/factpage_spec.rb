require 'spec_helper'

describe 'fact page', :js => true do

  it 'shows' do
    pending
    visit fact_path(Fact.first)
    page.should have_selector('html')
  end

end
