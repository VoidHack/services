Object subclass: Comment [
	| author text |

	author [ ^author ]
	text [ ^text ]

	author: aAuthor [ author := aAuthor ]
	text: aText [ text := aText ]
]

Object subclass: Vote [
	| author timestamp options |

	initialize [
		options := OrderedCollection new.
	]

	author [ ^author ]
	author: aAuthor [ author := aAuthor ]

	timestamp [ ^timestamp ]
	timestamp: aTimestamp [ timestamp := aTimestamp ]

	options [ ^options ]
	options: aOptions [ options := aOptions ]
]

SandstoneDb.SDActiveRecord subclass: Poll [
	| name comments expires options votes |

	initialize [
		super initialize.
		comments := OrderedCollection new.
		options := OrderedCollection new.
		votes := OrderedCollection new.
		expires := DateTime now.
	]

	name [ ^name ]
	comments [ ^comments ]
	options [
		options ifNil: [
			options := OrderedCollection new.
			self save.
		].
		^options
	]
	votes [ ^votes ]
	expires [ ^expires ]

	name: aName [ name := aName ]
	expires: aExpire [ expires := aExpire ]

	addComment: aComment [ comments add: aComment ]
	addOption: aOption [ options add: aOption ]
	addVote: aVote timestamp: aTimestamp [ aVote add: aTimestamp. votes add: aVote. ]
	expiresDate: aDate [ expires := DateTime date: aDate time: (expires asTime) ]
	expiresTime: aTime [ expires := DateTime date: (expires asDate) time: aTime ]
]
Poll warmUp.

DoodleComponent subclass: AddPollToSessionView [

	authenticate: aToken [
		| token |

		token := Token new.
		token deserialize: aToken.
		token validate.

		(token tokenvalue) ifNotNil: [
			Seaside.WACurrentSession value addPoll: (token tokenvalue)
		]
	]

	renderContentOn: html [
		html form class: 'pure-form';
				  with: [
				html textInput attributeAt: 'placeholder' put: 'Access Token';
							   callback: [ :aToken | self authenticate: aToken ].
				html submitButton value: 'Let me in!';
								  class: 'pure-button pure-button-primary'

			]
	]
]

DoodleComponent subclass: NewCommentView [
	renderContentOn: html [
		| newcomment |

		newcomment := Comment new.

		html heading level: 1;
					 with: 'Add a Comment'.

		html form class: 'pure-form pure-form-stacked';
				  with: [
			html label for: 'author';
					   with: 'Author'.
			html textInput callback: [ :value | newcomment author: value ];
						   id: 'author';
						   attributeAt: 'placeholder' put: 'Author'.
			html label for: 'comment';
					   with: 'Comment'.
			html textArea callback: [ :value | newcomment text: value ];
						  id: 'comment'.
			html submitButton callback: [ self answer: newcomment ];
							  value: 'Create';
							  class: 'pure-button pure-button-primary'.
		]
	]
]

DoodleComponent subclass: EditPollView [
	| poll addAccess |

	initialize [
		super initialize.
		addAccess := AddPollToSessionView new.
	]

	children [ ^{ addAccess } ]

	poll [
		^poll
	]

	poll: aPoll [
		poll := aPoll
	]

	pollId: aPollId [
		poll := Poll atId: aPollId
	]

	addContact [
		| cmmnt |
		cmmnt := self call: (NewCommentView new).
		poll addComment: cmmnt.
		poll save.
	]

	updateUrl: aUrl [
		super updateUrl: aUrl.
		aUrl addParameter: 'pollId' value: (poll id).
	]

	renderCommentOn: html comment: aComment [
		html div class: 'poll-comment-box';
				 with: [
				html heading level: 3;
							 with: (aComment author).
				html paragraph: (aComment text)
			]
	]

	renderVoteResult: aVote on: html [
		html tableRow: [
			html tableData: [ html render: aVote author ].
			aVote options do: [ :option |
				html tableData: [
					(option = #ok) ifTrue: [ html span class: 'fa fa-check'. ].
					(option = #meh) ifTrue: [ html span class: 'fa fa-question'. ].
					(option = #nope) ifTrue: [ html span class: 'fa fa-times'. ].
				].
			].
			html tableData: [ html render: aVote timestamp ].
		].
	]

	renderVoteOn: html [
		| vote |
		vote := Vote new.
		vote initialize.

		html tableRow: [
			html tableData: [
				html textInput attributeAt: 'placeholder' put: 'Your Name';
							   callback: [ :value | vote author: value ].
			].
			1 to: (poll options size) do: [ :aIndex |
				vote options add: #meh.
				html tableData: [
					| group |

					group := html radioGroup.
					group radioButton id: 'ok', aIndex asString;
									  callback: [ :value |
						vote options add: #ok afterIndex: aIndex.
						vote options removeAtIndex: aIndex.
					].
					html label for: 'ok', aIndex asString;
							   class: 'fa fa-check'.
					group radioButton id: 'meh', aIndex asString;
									  selected: true;
									  callback: [ :value |
						vote options add: #meh afterIndex: aIndex.
						vote options removeAtIndex: aIndex.
					].
					html label for: 'meh', aIndex asString;
							   class: 'fa fa-question'.
					group radioButton id: 'no', aIndex asString;
									  callback: [ :value |
						vote options add: #nope afterIndex: aIndex.
						vote options removeAtIndex: aIndex.
					].
					html label for: 'no', aIndex asString;
							   class: 'fa fa-times'.
				].
			].
			html tableData: [
				html submitButton callback: [
					vote timestamp: (DateTime now).
					vote inspect.
					poll votes add: vote.
					poll save. ];
								  value: 'Vote';
								  class: 'pure-button pure-button-primary'
			].
		].
	]

	renderOptionHeaderOn: html [
		html tableHead: [
			html tableRow: [
				html tableHeading: ''.
				poll options do: [ :aOption |
					html tableHeading: aOption.
				].
				html tableHeading: ''.
			].
		].
	]

	renderOptionsOn: html [
		html form class: 'pure-form pure-form-aligned';
				  with: [
			html table class: 'pure-table pure-table-striped';
					   with: [
				self renderOptionHeaderOn: html.
				html tableBody: [
					poll votes do: [ :vote |
							self renderVoteResult: vote on: html.
					].
					self renderVoteOn: html.
				].
				html tableFoot: [
					html tableRow: [
						html tableData: 'Summ:'.
						poll options do: [ :aOption |
							html tableData: 0.
						].
						html tableData: ''.
					].
				].
			].
		].
	]

	renderContentOn: html [
		| token |

		html heading
			level: 1;
			with: (poll name).
		(Seaside.WACurrentSession value hasAccess: (poll id)) ifTrue: [
			html paragraph with: [
				html render: 'The access token is: '.
				token := Token new.
				token tokenvalue: (poll id).
				token cryptography.
				html span class: 'access-token';
					      with: [ html render: (token serialize) ].
			].
			self renderOptionsOn: html.
			poll comments do: [ :comment |
					self renderCommentOn: html comment: comment
				].
			html anchor
				callback: [ self addContact ];
				with: 'Add Comment'
		] ifFalse: [
			html paragraph class: 'poll-error';
						   with: 'No access rights!'.
			html render: addAccess.
		]
	]
]

DoodleComponent subclass: ListPollView [
	editPoll: aPoll [
		| epView |

		epView := EditPollView new.
		epView poll: aPoll.
		self call: epView
	]

	renderPollRow: html poll: aPoll [
		(aPoll expires) < (DateTime now) ifFalse: [
			html tableRow: [
					html tableData: [
							 html anchor callback: [ self editPoll: aPoll ];
										 with: (aPoll name)
						].
					html tableData: (aPoll createdOn).
					html tableData: (aPoll expires)
				]
			]
	]

	renderContentOn: html [
		html heading level: 1;
					 with: 'Recent polls'.
		html table class: 'pure-table pure-table-striped';
				   with: [
				html tableHead: [
						html tableRow: [
								html tableHeading: 'Poll Name'.
								html tableHeading: 'Created'.
								html tableHeading: 'Expires'.
							]
					].
				html tableBody: [ Poll do: [ :poll | self renderPollRow: html poll: poll ] ]
			].
	]
]

DoodleComponent subclass: NewPollView [
	| poll options |

	initialize [
		super initialize.
		options := OrderedCollection new.
		options add: 'Option 1'.
		options add: 'Option 2'.
	]

	states [ ^{ self } ]

	optionField: html [
		1 to: (options size) do: [ :aIndex |
			html div class: 'pure-control-group';
					 with: [
				html textInput value: (options at: aIndex);
					 		   callback: [ :value |
					options add: value afterIndex: aIndex.
					options removeAtIndex: aIndex.
				]
			].
		].
	]

	save: aPoll [
		| view |

		options do: [ :aOption | aPoll addOption: aOption ].
		aPoll save.
		view := EditPollView new.
		view poll: aPoll.
		Seaside.WACurrentSession value addPoll: (aPoll id).
		self call: view.
	]

	renderContentOn: html [
		| newpoll |
		newpoll := Poll new.

		html heading level: 1;
					 with: 'Create a new Poll'.
		html form class: 'pure-form pure-form-aligned';
				  with: [
			html div class: 'pure-control-group';
				 	 with: [
				html label for: 'name';
					 	   with: 'Name'.
				html textInput callback: [ :value | newpoll name: value ];
					 		   id: 'name'.
			].
			html div class: 'pure-control-group';
				 	 with: [
				html label for: 'expiration';
					 	   with: 'Expires'.
				html dateInput callback: [ :value | newpoll expiresDate: value ];
					 		   id: 'expiration'.
				html render: ' at '.
				html timeInput callback: [ :value | newpoll expiresTime: value ].
			].
			html horizontalRule.
			self optionField: html.
			html div class: 'pure-control-group';
				 	 with: [
				html anchor callback: [ options add: 'New Option' ];
					 		with: 'More Options'.
			].
			html div class: 'pure-controls';
				 	 with: [
				html submitButton callback: [ self save: newpoll ];
								  value: 'Create';
								  class: 'pure-button pure-button-primary'
			]
	]
]
