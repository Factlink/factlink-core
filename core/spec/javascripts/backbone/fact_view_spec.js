describe("FactView", function() {
  beforeEach(function() {

  });

  it("should escape HTML in fields", function() {
    this.model = new Fact({
      displaystring: "baas<a>test</a> of niet"
    });
    
    this.view = new FactView({
      model: this.model,
      tmpl: "<span>{{ displaystring }}</span>"
    });
    
    this.view.render();
    
    expect($(this.view.el).find('a').length).toEqual(0);
  });
});