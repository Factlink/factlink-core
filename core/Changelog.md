#28-08-2013

##Functional
- Add a comment by default, instead of a Factlink
- Moved "Recent Factlinks" to auto-complete form.
- Re-designed the discussion page

##Technical
- Support global feature toggles:  we can now enable/disable new functionality
   on the live site using an application-wide feature toggle.
- Bootstrap has been moved to the Rails asset pipeline for better integration with our own CSS
- Updated Backbone to 0.9.9 and Marionette to 1.0.0-rc3.
- Update Pavlov to 0.1.7.1
- Upgraded Capybara to 2.1
- Added url normalization for newyorker.com
- Fixed crash on profile page of user with authority on a lot of topics
- Fixed XSS injection in your own name in the topbar
- Fix firefox (and IE) tooltips on svg's such as our factwheel.

#31-07-2013

- Comments are now also used in calculation the credibility of Factlinks.

#24-07-2013

- Increased the max length of a username to 20 characters
- Fixed a longstanding bug. We now highlight the correct Factlink when the cancel button has been used. (instead of also highlighting 'canceled' Factlinks)
- Removed relevance numbers for arguments

#22-07-2013

- Instead of showing the name of the logged-in user in a list of interacting users, show 'you' instead.
- Added percentage to the neutral tab

#07-06-2013

- We’ve improved the welcome tour for new users with a new section with featured users to follow on Factlink

# 16-05-2013

- Integration of topics in search. It’s now possible to search for topics through the search.
- Channels are removed for new users. New users won’t see channels anymore.
- Visitors of the Factlink blog can now see Factlinks without using the Factlink extension.

# 09-05-2013

- New account flow for new users. We’ve redesigned the complete registration and account completion flow.

# 02-05-2013

- To add a topic to your sidebar you can now go to a topic and click to ‘Follow’ button.

# 19-04-2013

- As part of our migration from channels to topics we’ve migrated and merged all user topics to generic topics.

# 11-04-2013

- You can now follow a Factlink user to stay updated about their Factlinks and activity.

# 04-04-2013

- All subchannels are migrated to topics with the same name

# 28-03-2013

- We’ve added loading indicators to our search, discussion page and the profile page.
- Channels has been renamed to topics. We’re working on a new more simple architecture with generic topics instead of user channels.
- When clicking on a topic you will see everything that has been posted to that topic.

# 21-03-2013

- We’ve a new page for new users to install the Factlink extension. It replaces our ‘old almost done’ page.
- Fixed a bug with social login through the Factlink extension

# 14-03-2013

- Social sign in/signup now uses a popup instead of full page redirects.
- New users will get better guidance when creating their first Factlink.
- We’ve simplified the way to follow a channel. You can now just press the follow button to follow a channel.

#15-01-2013

- Highlight Factlink when it enters the visible part of the window

#10-01-2013

- Notifications when somebody comments on a comment I interacted with.
- If you don't finish the tour, you will be redirected to the tour when you log in.
- Extracted and open sourced Pavlov library.
- Names on team page.
- Added animation in tour to show how you express your opinion. (by clicking the factwheel.)
- Manage the suggested topics list in the tour. (So no non english topics appear.)
- Bugfix: link of comment activity.
- Bugfix: fixed text of "A, B and C agreed this Factlink" (in client).
- Bugfix: HTML 5 placeholders don't work in IE7/IE8.
- Bugfix: Visiting Factlink public pages won't crash IE.
- Bugfix: Fixed layout of Factlink placeholders in tour.
