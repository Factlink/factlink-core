# Changelog

## Not released

### Functional:
- Social signin/signup now uses a popup instead of full page redirects.

## 16:30 CET, januari 15th, 2013

### Functional:
- Highlight Factlink when it enters the visible part of the window

## 15:00 CET, januari 10th, 2013

### Functional:
- Notfications when somebody comments on a comment I interacted with.
- If you don't finish the tour, you will be redirected to the tour when you log in.
- Extracted and opensourced Pavlov library.
- Names on team page.
- Added animation in tour to show how you express your opinion. (by clicking the factwheel.)
- Manage the suggested topics list in the tour. (So no non english topics appear.)
- Bugfix: link of comment activity.
- Bugfix: fixed text of "A, B and C agreed this Factlink" (in client).
- Bugfix: HTML 5 placeholders don't work in ie7/ie8.
- Bugfix: Visiting Factlink public pages won't crash IE.
- Bugfix: Fixed layout of factlink placeholders in tour.

### Technical:
- Client in a Backbone app (no navigation yet).
- restructured tests (renamed integration=>acceptence, extracted screenshot tests)
- Fix db:init
- Ensured assets are recompiled after locale update. (This was not automatically triggered.)

### Operational:
- Monitor all servers in New relic
- Per release keep track of changes in a changelog file.
