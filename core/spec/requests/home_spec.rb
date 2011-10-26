require 'spec_helper'

describe 'home page', :js => true do

  it 'welcomes the user' do
    visit '/'
    page.should have_content("Factlink helps people find credibility in the world's information")
  end
  
  it 'has no results on weird queries' do
    visit '/'
    fill_in 's', :with => "MyScrobidandoshanThis_@*&%&%&%WillHardMatchOnOurIndexDoesIt?!!@133377" # This probably will never give results
    page.execute_script("document.getElementsByTagName('form')[0].submit();") # Submits the form, since we don't have a clickable link or button
  
    page.should have_content("Your search didn't return any matching results.")
  end

end
