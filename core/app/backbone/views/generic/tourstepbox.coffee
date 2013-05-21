class TourStepBox extends Backbone.Marionette.ItemView
  className: 'white-well tour-block'

  events:
    'click .next-step': 'next'

  next: ->
    next_button = @$('.next-step')

    if next_button
      disableInputWithDisableWith(next_button)

    @trigger('next')

class window.AddChannelsTourStep1 extends TourStepBox
  template: 'tour/add_channel_step1'

class window.AddChannelsTourStep2 extends TourStepBox
  template: 'tour/add_channel_step2'
  templateHelpers: ->
    topics: Factlink.Global.t.topics.capitalize()
    channels: Factlink.Global.t.channels.capitalize()

class window.AddChannelsTourStep3 extends TourStepBox
  template: 'tour/add_channel_step3'
