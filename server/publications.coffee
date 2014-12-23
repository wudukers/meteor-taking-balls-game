Meteor.publish "gamerooms", ->
	Gamerooms.find()

Meteor.publish "game",(gameroomId) ->
	Game.find({gameroomId:gameroomId})

# Game.find({}, {sort: {createAt: -1}})
Meteor.publish "players", (gameroomId) ->
	Player.find({gameroomId:gameroomId})