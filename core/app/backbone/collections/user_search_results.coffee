class window.UserSearchResults extends SearchCollection
  model: User

  url: -> "/u/search.json?s=#{@query}"
