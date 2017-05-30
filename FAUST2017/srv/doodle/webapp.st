DoodleComponent subclass: DoodleApp [
	| currentView |

    DoodleApp class >> canBeRoot [ ^true ]

	initialize [
		super initialize.
		currentView := ListPollView new.
	]

    states [ ^{ self } ]

	children [ ^{ currentView } ]

	currentView: view [
		currentView := view
	]

	initialRequest: aRequest [
		super initialRequest: aRequest.
		aRequest fields at: 'pollId'
						ifPresent: [ :value |
							self currentView: (EditPollView new).
							currentView pollId: value.
						]
	]

	renderMenuItemOn: html callback: aCallback with: aName [
		html listItem
			class: 'pure-menu-item';
			with: [
				html anchor
					class: 'pure-menu-link';
					callback: aCallback;
					with: aName
			].
	]

	renderMenuOn: html [
		html div
			 class: 'pure-menu pure-menu-horizontal';
			 with: [
			 	html unorderedList
			 		class: 'pure-menu-list';
				  	with: [
						self renderMenuItemOn: html
							 callback: [ self currentView: (ListPollView new) ]
							 with: 'Home'.
						self renderMenuItemOn: html
							 callback: [ self currentView: (NewPollView new) ]
							 with: 'New Poll'.
						(Seaside.WACurrentSession value user) ifNil: [
							self renderMenuItemOn: html
								 callback: [ self currentView: (LoginUserView new) ]
								 with: 'Login'.
							self renderMenuItemOn: html
								 callback: [ self currentView: (NewUserView new) ]
								 with: 'New account'.
						] ifNotNil: [
							self renderMenuItemOn: html
								 callback: [ self currentView: (UserAccountView new) ]
								 with: 'Your account'.
						]
					]
			 ].
	]

	updateRoot: anHtmlRoot [
		super updateRoot: anHtmlRoot.
		anHtmlRoot stylesheet url: '/css/pure-min.css'.
		anHtmlRoot stylesheet url: '/css/font-awesome.min.css'.
		anHtmlRoot stylesheet url: '/css/doodle.css'.
	]

	renderContentOn: html [
		self renderMenuOn: html.
		html render: currentView.
		html horizontalRule.
		html text: 'Generated at: '.
		html render: (DateTime now).
	]
]

(DoodleApp registerAsApplication: 'doodle')
	preferenceAt: #sessionClass put: DoodleSession
