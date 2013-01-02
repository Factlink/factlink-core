#= require ./text_input_view

Backbone.Factlink ||= {}
class Backbone.Factlink.TextAreaView extends Backbone.Factlink.TextInputView
  template:
    text: '<textarea name="text_area_view" class="typeahead" placeholder="{{placeholder}}">{{text}}</textarea>'
