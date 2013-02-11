FactlinkApp.module "MemoryProfiler", (MemoryProfiler, MyApp, Backbone, Marionette, $, _) ->
  @on 'start', ->
    if Factlink.Global.can_haz.memory_profiling?
      MemoryProfiler.view_counts = {}
      MemoryProfiler.views = {}

      MemoryProfiler.view_count_collection = new ViewCountCollection

      old_constructor = Backbone.View::constructor
      # Note: This hack only works for Marionette views, since these views call
      # their super() constructor. Backbone.View's don't
      Backbone.View::constructor = (options)->
        old_constructor.apply @, arguments
        openView(this)
        @on 'close', => closeView(this)

  class MemoryView extends Marionette.ItemView
    tagName: 'tr'
    template:
      text: """
        <td>{{class_name}}</td><td>{{count}}</td>
      """

  class MemoriesView extends Marionette.CollectionView
    itemView: MemoryView

  class ViewCountCollection extends Backbone.Collection
    increaseCount: (view_name) ->
      model = @modelByName view_name
      if model
        model.set count: model.get('count') + 1
      else
        model = new Backbone.Model
          class_name: view_name
          count: 1
        @add model

    decreaseCount: (view_name) ->
      model = @modelByName view_name
      model.set count: model.get('count') - 1
      if model.get('count') == 0
        @remove model

    modelByName: (name) ->
      results = @where class_name: name
      if results.length > 0
        results[0]
      else
        null

    comparator: (model) -> -model.get('count')

  view_name_for = (view) ->
    classname = view.__proto__.constructor.name
    templatename = view.template

    if classname.length > 3
      classname
    else if typeof(templatename) is 'string'
      templatename
    else
      "unknown"

  openView = (view)->
    console.info('+CID ', view.cid)
    MemoryProfiler.views[view.cid] = view
    view_name = view_name_for(view)

    MemoryProfiler.view_counts[view_name] ||= 0
    MemoryProfiler.view_counts[view_name] = MemoryProfiler.view_counts[view_name] + 1

    MemoryProfiler.view_count_collection.increaseCount view_name

  closeView = (view)->
    console.info('-CID', view.cid)
    delete MemoryProfiler.views[view.cid]
    view_name = view_name_for(view)

    MemoryProfiler.view_counts[view_name] = MemoryProfiler.view_counts[view_name] - 1

    MemoryProfiler.view_count_collection.decreaseCount view_name


  MemoryProfiler.showModal = ->
    MemoryProfiler.view_count_collection.sort()
    memoryView = new MemoriesView collection: MemoryProfiler.view_count_collection
    FactlinkApp.Modal.show 'Views not closed', memoryView
