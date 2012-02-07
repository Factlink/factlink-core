test("Simple search", function(){
    equal(Factlink.search("Batman").length, 2, "Found Batman twice");
    equal(Factlink.search("character").length, 1, "Found character once");
    equal(Factlink.search("spiderman").length, 0, "No results for spiderman");
    
    equal(window.getSelection().rangeCount, 0, "Selection has been reset");
});

test("Search with ranges", function(){
    var selection = window.getSelection();    
    var range = document.createRange();
    range.selectNode($('#search-test p')[0]);
    selection.addRange(range);
    
    equal(Factlink.search("Batman").length, 2, "Found Batman twice with selected text");

    notEqual(selection.rangeCount, 0, "Rangecount is bigger then one");
    equal(selection.getRangeAt(0).toString(), range.toString(), "Range was reset");
})