SandstoneDb.SDActiveRecord subclass: User [
	| username password polls priviledges |

	initialize [
		super initialize.
		polls := Bag new.
		priviledges := Bag new.
		username := ''.
		password := ''
	]

	username [ ^username ]
	password [ ^password ]

	username: aUsername [ username := aUsername ]
	password: aPassword [ password := aPassword ]

	addPoll: aPollId [
		polls add: aPollId
	]

	polls [
		^polls
	]

	addPriviledge: aPriviledge [
		priviledges add: aPriviledge
	]

	hasAccess: aPollId [
		polls includes: aPollId
	]

	rank [
		 (priviledges size > 0) ifTrue: [
		 	(priviledges contains: 'Admin') ifTrue: 'Admin' ifFalse: 'Moderator'
		 ] ifFalse: [
		   	^'User'
		 ]
	]
]

Seaside.WASession subclass: DoodleSession [
	| priviledges polls user |

	initialize [
		super initialize.
		priviledges := Bag new.
		polls := Bag new.
	]

	unregistered [
		'Expiring session' printNl.
		user ifNotNil: [
			polls do: [ :aPoll |
				user addPoll: aPoll
			].
			user save.
		].
		super unregistered.
	]

	hasAccess: aPoll [
		^(polls includes: aPoll)
	]

	addPoll: aPoll [
		user ifNotNil: [
			 user addPoll: aPoll.
			 user save.
			].
		polls add: aPoll.
	]

	user: aUser [
		user := aUser.
		polls addAll: (user polls).
	]

	user [
		^user
	]
]

Seaside.WAComponent subclass: DoodleComponent [
	initialize [
		super initialize
	]
]
