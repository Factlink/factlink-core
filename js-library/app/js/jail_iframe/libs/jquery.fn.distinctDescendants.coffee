$.fn.distinctDescendants = ->
  $parents = []

  # Mark the parents of all given elements (which may also be
  # given elements themselves)
  # A naive version would be:
  # $(this).parents().data '$.fn.distinctDescendants.isParent', true
  # But we can do better by not continuing when encountering an ancestry
  # that has already been marked.
  # Finally, we save a list of marked elements so that we can clean up
  # efficiently also (otherwise this optimisation would be pointless).
  $(this).parentsUntil ->
    $parent = $(this)
    isParentAlready = $parent.data('$.fn.distinctDescendants.isParent')
    $parent.data '$.fn.distinctDescendants.isParent', true
    $parents.push $parent

    isParentAlready

  # Only keep elements that have not been marked as a parent
  elements = $(this).filter ->
    !$(this).data('$.fn.distinctDescendants.isParent')

  $parents.forEach ($parent) ->
    $parent.removeData '$.fn.distinctDescendants.isParent'

  $(elements)
