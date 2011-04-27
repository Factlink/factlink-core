(function( Factlink ) {
Factlink.CONF = {
    API: {
        loc: "http://tom:1337"
    },
    LIBRARY: {
        loc: "http://factlink:8000"
    },
    css: "http://factlink:8000/src/css/basic.css?" + (new Date()).getTime()
};
})( window.Factlink );