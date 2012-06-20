/*global test:true, equal:true, notEqual:true, _:true */

Factlink.getTemplate = function (str, callback) {
  callback(Factlink._.template(""));
};

// test("Simple search/replace", function(){

// });

// test("Search/replace should work with newlines", function () {
//   equal($('p.newline')[0].childNodes.length, 1);

//   Factlink.selectRanges(
//     Factlink.search("This text has multiple newlines"),
//     1,
//     {});

//   equal($('span.factlink')[0].childNodes.length, 1);
// });

// test("fact-span should have the data-factid attribute", function(){

//   Factlink.selectRanges(
//     Factlink.search("This text has multiple newlines"),
//     1,
//     {});

//   $('span.factlink').each(function(key, span) {
//     equal($(span).is("[data-factid]"), true);
//   });

// });
