(function( Factlink ) {
Factlink.conf = {
    api: {
        loc: "http://development.factlink.com"
    },
    lib: {
        loc: "http://chrome-extension.factlink.com"
    }
};

Factlink.conf.css = {
    loc: Factlink.conf.lib.loc + "/src/css/basic.css?" + (new Date()).getTime()
};
})( window.Factlink );