require 'acceptance_helper'

feature "available fonts", type: :feature do
  it "works" do
    visit "/"
    sleep 2
    page.should have_selector "#feedback_button"

    fonts = page.evaluate_script('''JSON.stringify(fontAvailability)''')
    puts fonts
    require 'pry';binding.pry
  end
end
#MacOSX: {"Lucida Grande":true,"Lucida Sans Unicode":true,"Lucida Sans":true,"Geneva":true,"Verdana":true,"Helvetica Neue":true,"Helvetica":true,"Arial":true,"cursive":true,"monospace":true,"serif":true,"sans-serif":true,"fantasy":true,"default":true,"Arial Black":true,"Arial Narrow":true,"Arial Rounded MT Bold":true,"Bookman Old Style":true,"Bradley Hand ITC":true,"Century":true,"Century Gothic":true,"Comic Sans MS":true,"Courier":true,"Courier New":true,"Georgia":true,"Gentium":true,"Impact":true,"King":true,"Lucida Console":true,"Lalit":true,"Modena":true,"Monotype Corsiva":true,"Papyrus":true,"Tahoma":true,"TeX":true,"Times":true,"Times New Roman":true,"Trebuchet MS":true,"Verona":true}

