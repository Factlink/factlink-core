Backbone.Factlink ||= {}

window.ReactCkeditorArea = React.createClass
  displayName: 'ReactCkeditorArea'

  shouldComponentUpdate: -> false

  _getLocalStorageBackup: ->
    if @props.defaultValue?
      @props.defaultValue
    else if @props.storageKey?
      safeLocalStorage.getItem(@props.storageKey)

  _setLocalStorageBackup: ->
    return unless @props.storageKey?

    if @_html
      safeLocalStorage.setItem(@props.storageKey, @_html)
    else
      safeLocalStorage.removeItem(@props.storageKey)

  _onChange: ->
    newHtml = @_editor.getData()
    return if newHtml == @_html

    @_html = newHtml

    @_setLocalStorageBackup()
    @props.onChange?(newHtml)

  updateHtml: (html) ->
    return if @_html == html
    @_editor.setData(html)
    @_onChange()

  focusInput: ->
    if @isMounted()
      @getDOMNode().focus()

  getHtml: -> @_html

  insertText: (text) -> #Not html!
    @_editor.insertText(text)
    @_onChange()

  insertHtml: (html) ->
    @_editor.insertHtml(html)
    @_onChange()

  componentWillUnmount: ->
    @_editor.destroy()

  componentDidMount: ->
    @_editor = CKEDITOR.inline(@getDOMNode(), Factlink.Global.ckeditor_config);
    @_editor.on 'change', @_onChange
    initialHtml = @_getLocalStorageBackup()
    @updateHtml initialHtml if initialHtml?

  render: ->
    _div
      contentEditable: true
      className: "ckeditor_contenteditable_area",
      placeholder: @props.placeholder || 'placeholder placeholder'
