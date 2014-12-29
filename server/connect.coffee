# Opening and closing of DDP connections
Meteor.onConnection (connection) ->
	console.log "[onConnection] connection = "
	console.log connection
	
	connection.onClose ->
		console.log "[onClose] connection = "
		console.log connection
		query = 
			connectId: connection.id
			connected: true
		updateData =
			connected: false
			closeAt: new Date


		UsersTracking.update query, {$set:updateData}

Meteor.methods
	getConnectionId: ->
		console.log "@.connection = "
		console.log @.connection
		@.connection.id

Meteor.methods
	logConnected: (uuid) ->
		query = 
			uuid: uuid
			connected: true
		updateData =
			connected: false
			closeAt: new Date

		UsersTracking.update query, {$set:updateData}

		query.connectId = @.connection.id
		if UsersTracking.find(query).count() is 0
			query.logAt = new Date
			UsersTracking.insert query

		else
			UsersTracking.findOne(query)._id

Meteor.publish "usersTracking", ->
	UsersTracking.find connectId:@connection.id 