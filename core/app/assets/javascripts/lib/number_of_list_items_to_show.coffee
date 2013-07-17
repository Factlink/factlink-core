# Gives the number of items from a list to show based on a list size
# and maximum number of items. To be used for lists which have an
# "and 4 others" postfix. This method prevents showing "and 1 other".

window.numberOfListItemsToShow = (listSize, maximumItems) ->
  if listSize <= maximumItems
    listSize
  else
    maximumItems - 1
