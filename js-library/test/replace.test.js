/*global test:true, asyncTest:true, start:true, equal:true, notEqual:true */

Factlink.set_position_of_element = function() {};

test("Search/replace should work with newlines", function () {
  equal($('p.newline')[0].childNodes.length, 1);

  Factlink.selectRanges(
    Factlink.search("This text has multiple newlines"),
    1,
    {});
  equal($('span.factlink')[0].childNodes.length, 1);
});

test("fact-span should have the data-factid attribute", function(){
  Factlink.selectRanges(
    Factlink.search("This text has multiple newlines"),
    1,
    {});

  $('span.factlink').each(function(key, span) {
    equal($(span).is("[data-factid]"), true);
  });
});

test("factlinks with different ranges count should work", function(){
  Factlink.selectRanges(
    Factlink.search("This is a link to an interesting page."),
    1,
    {});

  equal($('.first  span.factlink').length, 3);
  equal($('.second span.factlink').length, 1);
});

test("the first element in a factlink that is matched " +
     "multiple times with a different number of ranges " +
     "should have the fl-first class", function(){
  Factlink.selectRanges(
    Factlink.search("This is a link to an interesting page."),
    1,
    {});

  equal($('.first  span.factlink:first').is('.fl-first'), true);
  equal($('.second span.factlink:first').is('.fl-first'), true);
});

test("multiple Factlinks within the same element should be highlighted", function() {
  var factIdA = 2;
  var factIdB = 3;

  Factlink.selectRanges(Factlink.search("xxx"), factIdA, {});

  var els = $('.multi-match>.factlink');

  equal(els.eq(0).data('factid'), factIdA);
  equal(els.eq(1).data('factid'), factIdA);
});

asyncTest("Hovering highlights all the elements of the match, and no others", function () {
  var factA = {
    id: 1,
    str: "zzz"
  };

  var facts = Factlink.selectRanges(Factlink.search(factA.str), factA.id, {});

  $(facts[1].elements[0]).trigger('mouseenter',{
    target: facts[1].elements[0],
    pageX: 0,
    show_fast: true});

  // Wait for a bit until it actually highlights
  setTimeout(function() {
    equal($(facts[0].elements[0]).hasClass('fl-active'), false);
    equal($(facts[1].elements[0]).hasClass('fl-active'), true);
    equal($(facts[2].elements[0]).hasClass('fl-active'), false);
    equal($(facts[3].elements[0]).hasClass('fl-active'), false);

    start();
  }, 1000);

});
