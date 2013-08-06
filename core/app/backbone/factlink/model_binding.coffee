Backbone.Factlink ||= {}
Backbone.Factlink.ModelBinding =
  bind: ->
    if @model != null
      # Iterate through all bindings
      for selector, field of @modelBindings
        do (selector, field) =>
          console.log "binding #{selector} to #{field}"
          # When the model changes update the form
          # elements
          @model.on "change:#{field}", (model, val)=>
            console.log "model[#{field}] => #{selector}"
            el = @$(selector)
            if (el.attr('type') == 'checkbox')
              el.attr('checked', if val then 'checked' else null)
            else
              el.val(val)

          # When the form changes update the model
          [event, selector...] = selector.split(" ")
          selector = selector.join(" ")
          @$(selector).bind event, (ev)=>
            console.log "form[#{selector}] => #{field}"
            data = {}
            el = @$(ev.target)
            if (el.attr('type') == 'checkbox')
              data[field] = el.is(':checked')
            else
              data[field] = el.val()
            @model.set data
            @onBindChange() if @onBindChange

          # Set the initial value of the form
          # elements
          @$(selector).val(@model.get(field))

  # define an onBindChange if you want to execute code after
  # we changed the model because of a change in the modelbindings
