require 'spec_helper'

describe 'home page', :js => true do

  # it 'welcomes the user' do
  #   visit '/'
  #   page.should have_content('credibility you can see')
  # end
  # 
  # it 'has no results on weird queries' do
  #   visit '/'
  #   fill_in 's', :with => "MyScrobidandoshanThis_@*&%&%&%WillHardMatchOnOurIndexDoesIt?!!@133377" # This probably will never give results
  #   page.execute_script("document.getElementsByTagName('form')[0].submit();") # Submits the form, since we don't have a clickable link or button
  # 
  #   page.should have_content('No results found...')
  # end
  # 
  # it 'has results when querying "Batman" ' do
  #   visit '/'
  #   fill_in 's', :with => "Batman" # This probably will never give results
  #   page.execute_script("document.getElementsByTagName('form')[0].submit();") # Submits the form, since we don't have a clickable link or button
  # 
  #   # find('table.factlinks > tbody > tr > td:first').should have_content('Batman')
  # end

end
