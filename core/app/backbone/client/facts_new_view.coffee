  post_factlink: (e)->
    @ui.post_factlink.prop('disabled', true).text('Posting...')

    channel_ids = @addToCollection.pluck('id')

    fact = new Fact
      opinion: @wheel.get('current_user_opinion')
      displaystring: @options.fact_text
      fact_url: @options.url
      fact_title: @options.title
      channels: channel_ids

    fact.save {},
      success: =>
        fact.set containing_channel_ids: channel_ids
        @trigger 'factCreated', fact

  openOpinionHelptext: ->
    if FactlinkApp.guided
      @popoverAdd '.fact-wheel',
        side: 'left'
        align: 'top'
        margin: 20
        popover_className: 'fact-new-opinion-popover factlink-popover'
        contentView: new Backbone.Marionette.ItemView(template: 'tour/give_your_opinion')
    else
      @popoverAdd '.fact-wheel',
        side: 'top'
        popover_className: 'translucent-popover'
        contentView: new TextView text: "What's your opinion?"

  closeOpinionHelptext: ->
    @popoverRemove('.fact-wheel')

    if FactlinkApp.guided
      @openFinishHelptext()

  openFinishHelptext: ->
    unless @popoverOpened(".js-submit-post-factlink")?
      @popoverAdd '.js-submit-post-factlink',
        side: 'right'
        align: 'top'
        margin: 19
        container: @$('.js-finish-popover')
        contentView: new Backbone.Marionette.ItemView(template: 'tour/post_factlink')
