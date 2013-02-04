FactlinkApp.addInitializer (options)->
  if Factlink.Global.can_haz['memory_profiling']
    window.bekijks = {}
    Backbone.View.prototype.constructor = (options)->
      @cid = _.uniqueId('view')
      console.info('+CID ', @cid)
      window.bekijks[@cid] = this
      @_configure(options || {})
      @_ensureElement();
      @initialize.apply(this, arguments)
      @delegateEvents()
      @on 'close', =>
        console.info('-CID', @cid)
        delete window.bekijks[@cid]
