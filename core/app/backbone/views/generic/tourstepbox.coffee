class TourStepBox extends Backbone.Marionette.ItemView
  className: 'white-well tour-block'

  events:
    'click .next-step': 'next'

  next: ->
    next_button = @$el.find('.next-step')

    if next_button and next_button.data('disable-with')
      next_button.addClass('disabled').text(next_button.data('disable-with'))
    @trigger('next')

class window.AddChannelsTourStep1 extends TourStepBox
  template: 'tour/add_channel_step1'

class window.AddChannelsTourStep2 extends TourStepBox
  template: 'tour/add_channel_step2'

class window.AddChannelsTourStep3 extends TourStepBox
  template: 'tour/add_channel_step3'
