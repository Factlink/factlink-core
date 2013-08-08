/**
 * JavaScript code to detect available availability of a
 * particular font in a browser using JavaScript and CSS.
 *
 * Author : Lalit Patel
 * Website: http://www.lalit.org/lab/javascript-css-font-detect/
 * License: Apache Software License 2.0
 *          http://www.apache.org/licenses/LICENSE-2.0
 * Version: 0.15 (21 Sep 2009)
 *          Changed comparision font to default from sans-default-default,
 *          as in FF3.0 font of child element didn't fallback
 *          to parent element if the font is missing.
 * Version: 0.2 (04 Mar 2012)
 *          Comparing font against all the 3 generic font families ie,
 *          'monospace', 'sans-serif' and 'sans'. If it doesn't match all 3
 *          then that font is 100% not available in the system
 * Version: 0.3 (24 Mar 2012)
 *          Replaced sans with serif in the list of baseFonts
 */

/**
 * Usage: d = new Detector();
 *        d.detect('font name');
 */
var Detector = function() {

    //we use m or w because these two characters take up the maximum width.
    // And we use a LLi so that the same matching fonts can get separated
    var testString = "The Quick Brown Fox Jumps Over The Lazy Dog ";
    var testStrings = [];
    for(var i=1;i<testString.length;i++) {
        testStrings.push(testString.substr(0,i));
        testStrings.push(testString.substr(-i,i));
    }



    //we test using 72px font size, we may use any size. I guess larger the better.
    var testSize = '144px';

    var h = document.getElementsByTagName("body")[0];

    // create a SPAN in the document to get the width of the text we use to test
    var s = document.createElement("div"),
      a = document.createElement("div"),
      b = document.createElement("div");
    [a,b].forEach(function(el) {
        el.style.fontSize = testSize;
        el.style.lineHeight = '1';
        el.style.fontFamily = 'inherit';
        el.style.whiteSpace = 'pre';
        el.style.position = 'absolute';
        s.appendChild(el);
    });
    s.style.fontFamily = 'dfvb5w97vdkj';
    a.style.fontFamily = 'dfvb5w97vdkj';

    function getSizeDiff(font, base) {
    }

    function detect(font) {
        widthErr =0;
        heightErr=0;
        b.style.fontFamily = font;
        h.appendChild(s);
        testStrings.forEach(function(str) {
            a.textContent = str;
            b.textContent = str;
            widthErr += Math.abs(a.offsetWidth - b.offsetWidth);
            heightErr += Math.abs(a.offsetHeight - b.offsetHeight);
        });
        h.removeChild(s);
        return widthErr+ "/" +heightErr;
    }

    this.detect = detect;
};

interestingFonts = [ "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "Geneva", "Verdana",
 "Helvetica Neue", "Helvetica", "Arial",
"cursive",
"monospace",
"serif",
"sans-serif",
"fantasy",
"default",
"Arial",
"Arial Black",
"Arial Narrow",
"Arial Rounded MT Bold",
"Bookman Old Style",
"Bradley Hand ITC",
"Century",
"Century Gothic",
"Comic Sans MS",
"Courier",
"Courier New",
"Georgia",
"Gentium",
"Impact",
"King",
"Lucida Console",
"Lalit",
"Modena",
"Monotype Corsiva",
"Papyrus",
"Tahoma",
"TeX",
"Times",
"Times New Roman",
"Trebuchet MS",
"Verdana",
"Verona",
 ];

window.addEventListener('load', function(){
    var detect = new Detector().detect;
    window.fontAvailability = interestingFonts.reduce(function(o,font) {
        o[font] = detect(font);
        return o;
      }, {});
});
