class window.Following extends Backbone.Factlink.Collection
  model: User

  initialize: (models, options) ->
    @user = options.user

  url: -> "/#{@user.get('username')}/following"

  fetchOnce: (options={}) ->
    if @once_loaded
      options.success?()
    else if @loading()
      @waitForFetch options.success if options.success?
    else
      options.success = =>
        @once_loaded = true
        options.success?()
      @fetch options
