FactlinkApp.module "MemoryProfiler",
  startWithParent: not Factlink.Global.can_haz.memory_profiling?
  define: (MemoryProfiler, MyApp, Backbone, Marionette, $, _) ->
    @on 'start', ->
      MemoryProfiler.view_counts = {}
      MemoryProfiler.views = {}
      Backbone.View.prototype.constructor = (options)->
        @cid = _.uniqueId('view')
        openView(this)
        @_configure(options || {})
        @_ensureElement();
        @initialize.apply(this, arguments)
        @delegateEvents()
        @on 'close', => closeView(this)

    class MemoryView extends Marionette.ItemView
      tagName: 'tr'
      template:
        text: """
          <td>{{class_name}}</td><td>{{count}}</td>
        """

    class MemoriesView extends Marionette.CollectionView
      itemView: MemoryView

    openView = (view)->
      console.info('+CID ', view.cid)
      MemoryProfiler.views[view.cid] = view
      view_name = view.__proto__.constructor.name
      MemoryProfiler.view_counts[view_name] ||= 0
      MemoryProfiler.view_counts[view_name] = MemoryProfiler.view_counts[view_name] + 1

    closeView = (view)->
      console.info('-CID', view.cid)
      delete MemoryProfiler.views[view.cid]
      view_name = view.__proto__.constructor.name
      MemoryProfiler.view_counts[view_name] = MemoryProfiler.view_counts[view_name] - 1

    MemoryProfiler.showModal = ->
      view_count_array = []

      for view_name in Object.keys(MemoryProfiler.view_counts)
        view_count_array.push {class_name: view_name, count: MemoryProfiler.view_counts[view_name]}

      memoryView = new MemoriesView
        collection: new Backbone.Collection view_count_array

      FactlinkApp.Modal.show 'Views not closed', memoryView

