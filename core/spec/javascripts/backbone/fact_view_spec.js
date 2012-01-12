//= require frontend

describe("FactView", function() {
  beforeEach(function() {

  });

  it("should escape HTML in fields", function() {
    
    var path = "./tmp/mustache-templates.html?" + new Date().getTime();
    var xhr;
    
    try {
      xhr = new jasmine.XmlHttpRequest();
      xhr.open("GET", path, false);
      xhr.send(null);

      $("body").append(xhr.responseText);

    } catch(e) {
      throw new Error("couldn't fetch " + path + ": " + e);
    }
    
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