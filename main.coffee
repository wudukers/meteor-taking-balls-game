@Game = new Meteor.Collection "games"
@Player = new Meteor.Collection "players"

Game.allow
	update: ->
		true

if Meteor.isClient
	
	Meteor.startup -> 
		Meteor.subscribe("games")
		Meteor.subscribe("players")

	Template.gameroom.helpers
		data: ->
			Game.findOne()
		player1:->
			Player.find().fetch()[0]
		player2:->
			Player.find().fetch()[1]

	Template.gameroom.events
		"click .btn.btn-default": (e,t)->
			console.log 
			console.log "join game"
			Meteor.call "register", Meteor.user().profile.name, (err, res)->
				if not err
					console.log "res = "
					console.log res
				else
					console.log "err = "
					console.log err

	Template.inputfor.events
		"click .btn.btn-success": (e,t)->
			balls = $("input.numer").val()
			console.log "submit"
			$("input.numer").val("")
			Meteor.call "game_status", balls, (err,res)->
				if not err
					console.log "res = "
					console.log res
				else
					console.log "err = "
					console.log err

Meteor.methods
	"register":(player) ->
		console.log "start to register"
		pdata = Player.find().fetch()[0]
		
		if Meteor.user().profile.name == pdata or Meteor.user().profile.name == Player.find().fetch()[1]
			alert "wait another player"
		else if pdata 
			pdata2 =
				name: Meteor.user().profile.name
			Player.insert pdata2
			Session.set("player2",pdata2)
			console.log "register player2"
		else
			pdata = 
				name:Meteor.user().profile.name
			Player.insert pdata
			Session.set("player1",pdata)
			console.log "register player1"

	"game_status": (balls)->
		data = Game.find({}, {sort: {createAt: -1}}).fetch()[0]
		user = Meteor.user()
		player1 = Player.find().fetch()[0]
		player2 = Player.find().fetch()[1]

		if not (player1 or player2)
			alert "please register first"
			return

		if data
			#Game rule
			if data.balls <= 1
				alert "Game is over"
			else if user.profile.name == data.user
				alert "wait another player"
				throw new Meteor.Error(401, "wait another player")
			else if data.balls - balls > data.balls
				throw new Meteor.Error(401, "integer please")
			else if balls > 3 or balls < 1
				throw new Meteor.Error(401, "number must between 1-3")
			else
				updateData =
					user:user.profile.name
					balls: (data.balls - balls)
					createAt: new Date
				Game.update {_id:data._id}, {$set:updateData}
		else
			createData =
				user: user.profile.name
				balls: 50
				createAt: new Date
				player1: player1
				player2: player2
			Game.insert createData

if Meteor.isServer
	Meteor.publish "games", ->		
		Game.find()
# Game.find({}, {sort: {createAt: -1}})
	Meteor.publish "players", ->
		Player.find()