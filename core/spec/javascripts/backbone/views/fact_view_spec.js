describe("FactView", function() {
  template('mustache-templates.html');

  it("should escape HTML in fields", function() {
    var model = new Fact({
      displaystring: "baas<a>test</a> of niet",
      interacting_users: {
        activity: []
      }
    });

    var view = new FactView({
      model: model
    });

    view.render();

    expect(view.$el.find('span.body>a').length).toEqual(0);
  });
});