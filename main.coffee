@Game = new Meteor.Collection "games"

Game.allow
	update: ->
		true

if Meteor.isClient
	Meteor.subscribe("games")
	Meteor.subscribe("player")

	Template.gameroom.helpers
		data: ->
			Game.find({}, {sort: {createAt: -1}}).fetch()[0]
		player: ->
			Meteor.user()
		player2:"DADA"

	Template.inputfor.events
		"click .btn.btn-success": (e,t)->
			balls = $("input.numer").val()
			console.log "submit"
	
			Meteor.call "game_status", balls, (err,res)->
				$("input.numer").val("")

				if not err
	        console.log "res = "
	        console.log res

	      else
	        console.log "err = "
	        console.log err


Meteor.methods
	"game_status": (balls)->
		data = Game.find({}, {sort: {createAt: -1}}).fetch()[0]
		user = Meteor.user()
		if data
			console.log  "before" + data.balls,"after" + (data.balls-1)

			#Game rule
			if data.balls - balls > data.balls
				throw new Meteor.Error(401, "integer please")
			else if balls > 3 or balls < 1
				throw new Meteor.Error(401, "number must between 1-3")
			else
				updateData =
					user:user.profile.name
					balls:data.balls - balls
					createAt: new Date
					player: "p1"
				Game.update {_id:data._id}, {$set:updateData}
		else
			createData =
				user: user.profile.name
				balls: 50
				createAt: new Date
			Game.insert createData

if Meteor.isServer
	Meteor.publish "games", ->
		Game.find()
	Meteor.publish "player", ->
		user = Meteor.user()
		if not user
			throw new Meteor.Error(401, "You need to login first")
		Meteor.user()
		# Game.find({}, {sort: {createAt: -1}})