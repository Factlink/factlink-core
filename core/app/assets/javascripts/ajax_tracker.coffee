#see http://stackoverflow.com/questions/3313059/jquery-abandon-all-outstanding-ajax-requests/3313954#3313954

active_xhr = []
$.ajaxSetup(
  beforeSend: (newreq) ->
    active_xhr.push(newreq)
    newreq.always( -> active_xhr = active_xhr.filter((req) -> req != newreq))
    return
)

window.listAllAjaxRequests = -> active_xhr.slice(0)

window.abortAllAjaxRequests = ->
  active_xhr.forEach((req) -> req.abort())
  active_xhr = []
  return

