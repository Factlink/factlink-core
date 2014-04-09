window.string_hash = (str) ->
  # returns a (possibly negative) integer

  # note: usage of << ensure we stick to integral arithmetic.
  # equiv to the standard *31
  i = hash = str.length
  while i
    i--
    hash = (hash<<5) - hash + str.charCodeAt(i)
  hash
