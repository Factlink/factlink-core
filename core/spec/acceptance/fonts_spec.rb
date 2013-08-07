require 'acceptance_helper'

feature "available fonts", type: :feature do
  it "works" do
    visit "/"
    sleep 2
    page.should have_selector "#feedback_button"

    fonts = page.evaluate_script('''JSON.stringify(fontAvailability)''')
    puts fonts
  end
end

