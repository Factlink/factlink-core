module Acceptance
  module NotificationHelper
    def assert_number_of_unread_notifications nr
      find('#notifications .unread', text: nr.to_s, visible: false)
      #TODO: WARNING: 'visible: false' is here to replicate the behavior of a
      # prexisting buggy test; this should be removed, ASAP!

      #run log of notifications_spec.rb:10 with this bug pre capybara 2:

      # Run options: exclude {:slow=>true}
      #
      # From: /Users/eamon/dev/fl/core/spec/acceptance/notifications_spec.rb @ line 26 :
      #
      #     21:     as(other_user) do |p|
      #     22:       p.old_interactor :'channels/add_subchannel', other_users_channel.id, my_channel.id
      #     23:     end
      #     24:
      #     25:     sign_in_user current_user
      #  => 26:     require 'pry'; binding.pry
      #     27:
      #     28:     assert_number_of_unread_notifications 1
      #     29:     open_notifications
      #     30:     click_on_nth_notification 1
      #     31:     assert_on_channel_page other_users_channel.title
      #
      # [1] pry(#<RSpec::Core::ExampleGroup::Nested_1>)> all('#notifications .unread')
      # => [#<Capybara::Element tag="span">, #<Capybara::Element tag="li">]
      # [2] pry(#<RSpec::Core::ExampleGroup::Nested_1>)> all('#notifications .unread')[0].text
      # => "0"
      # [3] pry(#<RSpec::Core::ExampleGroup::Nested_1>)> all('#notifications .unread')[1].text
      # => "John2 Doe2 is now following you on Channel title 2 1 minute ago Follow"

      #note the '1' in the string above!

      # [4] pry(#<RSpec::Core::ExampleGroup::Nested_1>)> all('#notifications .unread', text: '1')
      # => [#<Capybara::Element tag="li">]
      # [5] pry(#<RSpec::Core::ExampleGroup::Nested_1>)> all('#notifications .unread', text: '1')[0].text
      # => "John2 Doe2 is now following you on Channel title 2 1 minute ago Follow"

      #Oops!
    end

    def open_notifications
      find('#notifications a.dropdown-toggle').click
    end

    def within_first_notification &block
      within("#notifications .dropdown-menu li") do
        yield
      end
    end
  end
end
