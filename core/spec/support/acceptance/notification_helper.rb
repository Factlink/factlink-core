module Acceptance
  module NotificationHelper
    def assert_number_of_unread_notifications nr
      find('#notifications .unread', text: nr.to_s)
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
