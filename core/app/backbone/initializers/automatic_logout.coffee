FactlinkApp.automaticLogoutInitializer = ->
  FactlinkApp.vent.on 'require_login', ->
    $('body').html ''
    $('body').css(
      'background-color': '#313131'
      width:'100%'
      height:'100%'
    )

    window.location.reload()
