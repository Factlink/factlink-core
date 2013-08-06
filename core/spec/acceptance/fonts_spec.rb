require 'acceptance_helper'

feature "available fonts", type: :feature do
  it "works" do
    visit "/"
    page.should have_selector "#feedback_button"
    fonts = page.evaluate_script('''(function(){
        var detect = new Detector().detect;
        var fonts = interestingFonts.reduce(function(o,font) {
            o[font] = detect(font);
            return o;
          }, {});
        return JSON.stringify(fonts);
      })()''')
    puts fonts
    # require 'pry';binding.pry
  end
end
