FactlinkApp.addInitializer (options)->
  FactlinkApp.vent.on 'require_login', ()->
    $('body').html ''
    $('body').css(
      'background-color': '#313131'
      width:'100%'
      height:'100%'
    )

    alert "You have been signed out, please sign in."
    window.location = Factlink.Global.path.sign_in