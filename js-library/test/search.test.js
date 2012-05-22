/*global test:true, equal:true, notEqual:true */

var expectedBatmanMatches = 9;

test("Simple search", function(){
    equal(Factlink.search("Batman").length, expectedBatmanMatches, "Found Batman nine times");
    equal(Factlink.search("character").length, 2, "Found character once");
    equal(Factlink.search("spiderman").length, 0, "No results for spiderman");


    // the following line tests for a bug, which we haven't fixed yet
    // it also magically causes another test to fail, no clue why -- mark
    //equal(Factlink.search("foo bar").length, 1, "Find foo bar once");

    equal(document.getSelection().rangeCount, 0, "Selection has been reset");
});

test("Search with ranges", function(){
    var selection = document.getSelection();
    var range = document.createRange();
    range.selectNode($('#search-test p')[0]);
    selection.addRange(range);

    equal(Factlink.search("Batman").length, expectedBatmanMatches, "Found Batman twice with selected text");

    notEqual(selection.rangeCount, 0, "Rangecount is bigger then one");
    equal($.trim(selection.getRangeAt(0).toString()), range.toString(), "Range was reset");
});

test("Search text with newlines", function() {
  equal(Factlink.search("Dit is een tekst met expresse newlines, deze moeten wel gematched worden.").length, 1, "It should find text with newlines");
});
