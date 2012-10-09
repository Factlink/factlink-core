class window.MessageView extends Backbone.Marionette.ItemView
  template:
    text: """
          <h1>Gerard stuurde je deze factlink</h1>
          <p><b>Sommige dingen zijn waar</b></p>
          <p>Wat vind jij daarvan?</p>
          <textarea></textarea><br>
          <input type="submit" value="Verstuur">
    """