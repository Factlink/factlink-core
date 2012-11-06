describe('FactView', function () {
  it('should call render', function() {
    var model = new Fact({
      displaystring: 'test'
    });

    spyOn(model, 'getFactWheel');
    spyOn(window, 'Wheel').andReturn({set: function() {}});
    spyOn(window, 'InteractiveWheelView').andReturn({render: function() {}});
    spyOn(window, 'FactTabsView').andReturn({render: function() {}});
    render = spyOn(Backbone.Marionette.Renderer, 'render');

    var view = new FactView({
      model: model
    });
    
    view.render();

    expect(Backbone.Marionette.Renderer.render).toHaveBeenCalledWith(
      'facts/_fact',
      {displaystring: 'test'},
      {fact_bubble: undefined, fact_wheel: undefined, interacting_users: undefined}
    );
  });
});
