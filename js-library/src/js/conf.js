(function( Factlink ) {
Factlink.conf = {
    api: {
        // loc: "http://demo.factlink.org"
        loc: "http://localhost:3000"
    },
    lib: {
        loc: "http://static.factlink.com/lib"
    }
};

// Add the stylesheet
var style = document.createElement("link");
style.type = "text/css";
style.rel = "stylesheet";
style.href = Factlink.conf.lib.loc + "/src/css/basic.css?" + (new Date()).getTime();
document.getElementsByTagName("head")[0].appendChild(style);

})( window.Factlink );