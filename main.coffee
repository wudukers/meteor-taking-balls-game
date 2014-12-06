@Dashboard = new Meteor.Collection "dashboard"

if Meteor.isClient
    Template.dashboard.helpers
        games: ->
            Dashboard.find({}, {sort: {createAt: -1}})

    Template.dashboard.events
      "change input.game-name": (e, t) ->
        e.stopPropagation()

        gamename = $("input.game-name").val()
        $("input.game-name").val("")

        Meteor.call "insertGame", gamename, (err, data) ->
            console.log "data"
            console.log data

if Meteor.isServer
    Meteor.methods
        "insertGame": (gamename) ->
            user = Meteor.user()
            if ! user
                throw  new Meteor.Error(401, "Please Login First.")
            username = user.profile.name 
            userId = user._id
            gamename = gamename
            
            data = 
                userId: userId
                username: username
                gamename:  gamename
                createAt: new Date
            Dashboard.insert data
