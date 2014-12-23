Template.index.events
	"click input.btn.btn-xs.btn-default": (e,t)->
		room_name = $("input.gameroomName").val()
		console.log room_name
		$("input.gameroomName").val("")
		Meteor.call "create a game room", room_name, (err, res)->
			if not err
				console.log "res = "
				console.log res
			else
				console.log "err = "
				console.log err