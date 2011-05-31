(function( Factlink ) {
Factlink.conf = {
    api: {
        loc: "http://demo.factlink.org"
        // loc: "http://localhost:3000"
    },
    lib: {
        loc: "http://static.demo.factlink.org/lib"
    }
};

Factlink.conf.css = {
    loc: Factlink.conf.lib.loc + "/src/css/basic.css?" + (new Date()).getTime()
};
})( window.Factlink );