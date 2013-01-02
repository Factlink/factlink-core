Backbone.Factlink ||= {}
Backbone.Factlink.listSeparator = (total_length, length, index) ->
  # when we show the emptyview, the collection is
  # empty, but conceptually the length is 1
  length = 1 if length == 0

  last_index = length - 1

  is_penultimate = index == last_index - 1
  we_see_all_items = total_length <= length
  isnt_last = index != last_index

  if is_penultimate and we_see_all_items
    ' and '
  else if isnt_last
    ', '
  else
    null
