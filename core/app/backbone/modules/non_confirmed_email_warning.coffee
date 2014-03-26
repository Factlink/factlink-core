checkConfirmedEmail = ->
  return unless FactlinkApp.signedIn()
  return if currentSession.user().get('confirmed')
  return if currentSession.user().justCreated()

  FactlinkApp.NotificationCenter.error """
    Your email address has not yet been confirmed, please check your email inbox.
    <a href="/users/confirmation/new" target="_blank">
      Resend email.
    </a>
  """


class window.NonConfirmedEmailWarning
  constructor: ->
    checkConfirmedEmail()
    currentSession.on 'change', checkConfirmedEmail
