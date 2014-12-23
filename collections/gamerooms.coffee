@Game = new Meteor.Collection "game"
@Gamerooms = new Meteor.Collection "gamerooms"
@Player = new Meteor.Collection "players"

Game.allow
	update: ->
		true

Gamerooms.allow
	update: ->
		true

Meteor.methods
	"create a game room": (room_name)->
		console.log "create a game room"
		room_data =
			room_name:room_name
			createAt: new Date
			creator: Meteor.user().profile.name
		Gamerooms.insert room_data

	"register":(gameroomId) ->
		pdata1 = Player.find({gameroomId:gameroomId}).fetch()[0]
		pdata2 = Player.find({gameroomId:gameroomId}).fetch()[1]
		
		if (Meteor.user().profile.name == pdata1) or (Meteor.user().profile.name == pdata2)
			alert "wait another player register"
			"wait another player register"
		else if pdata1
			pdata2 =
				gameroomId: gameroomId
				name: Meteor.user().profile.name
			Player.insert pdata2
		else
			pdata1 = 
				gameroomId: gameroomId
				name:Meteor.user().profile.name
			console.log "register player1"
			Player.insert pdata1
		"register"

	"start a game": (gameroomId)->
		user = Meteor.user()
		data = Game.find({gameroomId:gameroomId})
		#for init game
		player1 = Player.find({gameroomId:gameroomId}).fetch()[0]
		player2 = Player.find({gameroomId:gameroomId}).fetch()[1]

		if user.profile.name
			createData =
				user: user.profile.name
				balls: 50
				createAt: new Date
				player1: player1.name
				player2: player2.name
				gameroomId: gameroomId
			Game_id = Game.insert createData
			updateData =
				Game_id:Game_id
			Player.update {_id:player1._id}, {$set:updateData}
			Player.update {_id:player2._id}, {$set:updateData}
		else
			alert "you can't play this round or create your own game room"
		"start a game"

	"game_status": (balls, gameroomId)->
		data = Game.find({gameroomId:gameroomId}, {sort: {createAt: -1}}).fetch()[0]
		user = Meteor.user()
		#for init game
		player1 = Player.find({gameroomId:gameroomId}).fetch()[0]
		player2 = Player.find({gameroomId:gameroomId}).fetch()[1]

		#game rule
		if data
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
					gameroomId: gameroomId
					user:user.profile.name
					balls: (data.balls - balls)
					createAt: new Date
				Game.update {_id:data._id}, {$set:updateData}
		else
			alert "please click start game"
		"set game status"