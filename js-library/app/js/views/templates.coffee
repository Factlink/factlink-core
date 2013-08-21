requesting = {}

Factlink.templates = {}

Factlink.templates.getTemplate = (str, callback = ->) ->
  if str == "create"
    callback _.template """
      <div class="fl-add-new fl-popup">
        <span class="fl-default-message">
          <span class="fl-new"><a href="#">Add Factlink</a></span>
          <span class="fl-created">Added</span>
        </span>

        <span class="fl-loading-message">Loading...</span>
      </div>
    """
  else if str == "indicator"
    callback _.template """
      <div class="fl-popup" style="display:none">
        <span class="fl-default-message">Show Factlink</span>
        <span class="fl-loading-message">Loading...</span>
      </div>
    """
  else alert "meh"

Factlink.templates.preload = ->
  Factlink.templates.getTemplate 'indicator'
  Factlink.templates.getTemplate 'create', (template) ->
    Factlink.prepare = new Factlink.Prepare(template)
