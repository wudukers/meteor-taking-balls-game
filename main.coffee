@Game = new Meteor.Collection "games"

if Meteor.isClient
	Meteor.subscribe("games")
	Template.gameroom.helpers
		data: ->
			Game.find({}, {sort: {createAt: -1}}).fetch()[0]
		user1:"David"
		user2:"wen777"
	Template.inputfor.events
		"click .btn.btn-success": (e,t)->
			
			number = $("input.numer").val()
			# console.log number
			console.log "click me "
			Meteor.call "game.ststus", number

Meteor.methods
	"game.ststus": (balls)->
		user = Meteor.user()
		if not user
			throw new Meteor.Error(401, "You need to login first")

		if Game.findOne()
			# console.log (Game.find().fetch()[0].round)
			data = Game.find({}, {sort: {createAt: -1}}).fetch()[0]
			round = (data.round + 1)
			console.log "round:"+round

			data =
				round: round
				user: user.profile.name
				balls: balls
				createAt: new Date
		else
			data =
				round: 1
				user: user.profile.name
				balls: 50
				createAt: new Date
			
		Game.insert(data)

if Meteor.isServer
	Meteor.publish "games", ->
		Game.find({}, {sort: {createAt: -1}})