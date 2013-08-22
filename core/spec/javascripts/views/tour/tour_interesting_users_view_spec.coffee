#= require jquery
#= require application
#= require frontend

describe 'TourInterestingUsersView', ->

  describe '8 users in total, spanning 2 pages, 2x2 grid', ->
    beforeEach ->
      window.currentUser = new User

      # Grid of 2x2, with each user 10 pixels wide
      # (10px) (10px)
      # (10px) (10px)
      @collection = new TourUsers new Array(8)
      @view = new TourInterestingUsersView
        collection: @collection
        numberOfUsersInX: 2
        numberOfUsersInY: 2
        userListItemWidth: 10
      @view.render()

    describe 'initially', ->
      it 'has no previous page', ->
        expect(@view.hasPreviousPage()).to.be.false

      it 'has a next page', ->
        expect(@view.hasNextPage()).to.be.true

      it 'sets the width of the scrolling inner to 40px (total horizontal width)', ->
        expect(@view.$('.js-scrolling-inner').width()).to.equal 40

    describe 'after going to the second page', ->
      beforeEach ->
        @view.showNextPage()

      it 'moves the scrolling inner with 20px', ->
        expect(@view.$('.js-scrolling-inner').css('left')).to.equal '-20px'

      it 'has a previous page', ->
        expect(@view.hasPreviousPage()).to.be.true

      it 'has no next page', ->
        expect(@view.hasNextPage()).to.be.false
