/*global test:true, equal:true, notEqual:true, _:true */

test("Simple search/replace", function(){

});

test("Search/replace should work with newlines", function () {
  equal($('p.newline')[0].childNodes.length, 1);

  Factlink.getTemplate = function (str, callback) {
    callback(Factlink._.template(""));
  };

  Factlink.selectRanges(
    Factlink.search("This text has multiple newlines"),
    1,
    {});

  equal($('span.factlink')[0].childNodes.length, 1);
});
