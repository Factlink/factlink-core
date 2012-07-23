class TourStepBox extends Backbone.Marionette.ItemView
  className: 'white-well tour-block'

  events:
    'click .next-step': 'next'

  next: -> @trigger('next')

class window.AddChannelsTourStep1 extends TourStepBox
  template: 'generic/tour/_add_channel_step1'

class window.AddChannelsTourStep2 extends TourStepBox
  template: 'generic/tour/_add_channel_step2'

class window.AddChannelsTourStep3 extends TourStepBox
  template: 'generic/tour/_add_channel_step3'