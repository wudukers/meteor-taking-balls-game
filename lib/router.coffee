Router.configure
	layoutTemplate: 'layout'
# Meteor.startup -> 
Router.map -> 
	@route "index",
		path: "/"
		template: "index"
		data:
			user: ->
				Meteor.user()
			gamerooms:->
				Gamerooms.find({}, {sort:{createAt:-1}})
		waitOn:->
			Meteor.subscribe "gamerooms"
	@route "gameroom",
		path: "/gameroom/:gameroomId"
		template: "gameroom"
		data:
			user:->
				Meteor.user()
			game:->
				gameroomId = Session.get("gameroomId")
				Game.find({gameroomId:gameroomId}, {sort:{createAt:-1}})
		waitOn:->
			Session.set "gameroomId", @params.gameroomId
			# Session.set("player" , Meteor.user().profile.name)
			Meteor.subscribe "game", @params.gameroomId
			Meteor.subscribe "players", @params.gameroomId