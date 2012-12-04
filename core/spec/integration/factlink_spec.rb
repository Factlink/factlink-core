require 'integration_helper'

def create_factlink(user)
  FactoryGirl.create(:fact, created_by: user.graph_user)
end

describe "factlink", type: :request do
  include FactHelper

  before :each do
    @user = sign_in_user FactoryGirl.create :approved_confirmed_user
  end

  it "the layout of the discussion page is correct" do
    @factlink = create_factlink @user
    search_string = 'Test search'

    visit friendly_fact_path(@factlink)
    sleep 2
    wait_for_ajax
    assume_unchanged_screenshot "discussion_page"
  end

  it "evidence can be added" do
    @factlink = create_factlink @user
    search_string = 'Test search'

    visit friendly_fact_path(@factlink)

    page.should have_content(@factlink.data.title)

    wait_until_scope_exists '.auto-complete-fact-relations' do
      input = page.find(:css, 'input')
      input.set(search_string)
      input.trigger('focus')

      wait_for_ajax
    end

    page.find('.fact-relation-post').click

    page.should have_selector('li.evidence-item')
    within(:css, 'li.evidence-item') do
      page.should have_content search_string
    end
  end

  it "can be agreed" do
    @factlink = create_factlink @user
    search_string = 'Test search'

    visit friendly_fact_path(@factlink)

    page.should have_content(@factlink.data.title)

    agreed_path_position = 0

    old_agreed_path_opacity = wheel_path_opactity agreed_path_position
    old_agreed_path_shape = wheel_path_d agreed_path_position

    click_wheel_part agreed_path_position

    old_agreed_path_opacity.should_not eq wheel_path_opactity agreed_path_position
    old_agreed_path_shape.should_not eq wheel_path_d agreed_path_position
  end

  it "can be neutraled" do
    @factlink = create_factlink @user
    search_string = 'Test search'

    visit friendly_fact_path(@factlink)

    page.should have_content(@factlink.data.title)

    neutral_path_position = 1

    old_neutral_path_opacity = wheel_path_opactity neutral_path_position
    old_neutral_path_shape = wheel_path_d neutral_path_position

    click_wheel_part neutral_path_position

    old_neutral_path_opacity.should_not eq wheel_path_opactity neutral_path_position
    old_neutral_path_shape.should eq wheel_path_d neutral_path_position
  end

  it "can be disagreed" do
    @factlink = create_factlink @user
    search_string = 'Test search'

    visit friendly_fact_path(@factlink)

    page.should have_content(@factlink.data.title)

    disagreed_path_position = 2

    old_disagreed_path_opacity = wheel_path_opactity disagreed_path_position
    old_disagreed_path_shape = wheel_path_d disagreed_path_position

    click_wheel_part disagreed_path_position

    old_disagreed_path_opacity.should_not eq wheel_path_opactity disagreed_path_position
    old_disagreed_path_shape.should_not eq wheel_path_d disagreed_path_position
  end

  it "should find a factlink when searching on a exact phrase containing small words" do
    pending "because there's an open asap point to fix elasticsearchrelated bugs"
    displaystring = 'feathers is not a four letter groom betters'

    @factlink = create_factlink @user

    @factlink_evidence = create_factlink @user
    @factlink_evidence.data.displaystring = "Fact: " + displaystring
    @factlink_evidence.data.save

    visit friendly_fact_path(@factlink)
    page.should have_content(@factlink.data.title)

    click_on "Agreeing"

    wait_until_scope_exists '.add-evidence-container' do
      fill_in 'supporting_search', :with => displaystring
      wait_for_ajax
    end

    page.should have_content @factlink_evidence.data.displaystring
  end

  def wheel_path_d position
    page.evaluate_script("$('.fact-wheel path')[#{position}].getAttribute('d');");
  end

  def wheel_path_opactity position
    page.evaluate_script("$('.fact-wheel path')[#{position}].style.opacity;");
  end

  def click_wheel_part position
    #fire click event on svg element
    page.execute_script("var path = $('.fact-wheel path')[#{position}];var event = document.createEvent('MouseEvents'); event.initMouseEvent('click');path.dispatchEvent(event);")

    wait_for_ajax

    #wait for animation
    sleep 0.2
  end
end
