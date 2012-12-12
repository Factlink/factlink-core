module Acceptance
  module NotificationHelper
    def assert_number_of_unread_notifications nr
      find('#notifications .unread', text: nr.to_s)
    end

    def open_notifications
      find('#notifications a.dropdown-toggle').click
    end

    def click_on_nth_notification nr
      find("#notifications .dropdown-menu li[#{nr}] a").click
    end
  end
end
