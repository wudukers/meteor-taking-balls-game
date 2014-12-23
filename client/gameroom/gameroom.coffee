# Template.gameroom.helpers
# 	data: ->
# 		Game.findOne()
# 	player1:->
# 		Player.find().fetch()[0]
# 	player2:->
# 		Player.find().fetch()[1]

Template.gameroom.events
	"click input.btn.btn-default.register": (e,t)->
		gameroomId = Session.get("gameroomId")
		Meteor.call "register", gameroomId, (err, res)->
			if not err
				console.log "res = "
				console.log res
			else
				console.log "err = "
				console.log err
	"click input.btn.btn-default.start": (e,t)->
		gameroomId = Session.get("gameroomId")
		user = Meteor.user()
		if not Meteor.user()
			console.log  "signup first"
		else if not user.profile.name
			alert "login first"
		Meteor.call "start a game", gameroomId, (err,res)->
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
		gameroomId = Session.get("gameroomId")

		patt1 = /\b[1-3]{1}/g
		balls = balls.match patt1

		if parseInt(balls, 10)
			Meteor.call "game_status", balls, gameroomId, (err,res)->
				if not err
					console.log "res = "
					console.log res
				else
					console.log "err = "
					console.log err
		else
			alert "please give integer(1~3), not " + balls