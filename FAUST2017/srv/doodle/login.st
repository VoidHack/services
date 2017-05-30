DoodleComponent subclass: UserAccountView [
	renderContentOn: html [
		| user |
		user := Seaside.WACurrentSession value user.

		html heading level: 1;
					 with: [
					 html render: 'Welcome back '.
					 html render: user username.
			].
		html render: 'Your status is: '.
		html render: user rank.
		html break.
		html render: 'Your tokens: '.
		user polls do: [ :aPoll |
			html render: aPoll.
			html render: ', '.
		]
	]
]

DoodleComponent subclass: NewUserView [
	| user pw1 pw2 error |

	initialize [
		super initialize.
		user := User new.
	]

	save [
		| uaView otheruser |
		(pw1 = pw2) ifTrue: [
			otheruser := User find: [ :each | each username = user username ].

			otheruser ifNil: [
				user password: pw1.
				user save.
				uaView := UserAccountView new.
				Seaside.WACurrentSession value user: user.
				self call: uaView
			] ifNotNil: [
				error := 'User already exists'.
			]
		]
	]

	renderContentOn: html [
		html heading level: 1;
					 with: 'Create an Account'.
		error ifNotNil: [
			 html paragraph class: 'poll-error';
							with: error.
		].
		html form class: 'pure-form pure-form-aligned';
				  with: [
			html div class: 'pure-control-group';
					 with: [
				html label for: 'username';
						   with: 'Username'.
				html textInput callback: [ :value | user username: value ];
							   value: (user username);
							   id: 'username'.
			].
			html div class: 'pure-control-group';
					 with: [
				html label for: 'pw1';
					 	   with: 'Password'.
				html passwordInput callback: [ :value | pw1 := value ];
					 			   id: 'pw1'.
			].
			html div class: 'pure-control-group';
					 with: [
				html label for: 'pw2';
					 	   with: 'Password (repeat)'.
				html passwordInput callback: [ :value | pw2 := value ];
					 			   id: 'pw2'.
			].

			html div class: 'pure-controls';
				 	 with: [
				html submitButton callback: [ self save ];
					  			  value: 'Create';
								  class: 'pure-button pure-button-primary'.
			]
		]
	]
]

DoodleComponent subclass: LoginUserView [
	| username password error |

	login [
		| user |

		user := User find: [ :obj | obj username = username ].
		user ifNotNil: [
			(user password = password) ifTrue: [
				Seaside.WACurrentSession value user: user.
				self call: UserAccountView new.
			] ifFalse: [
				error := 'Username / Password does not exist'.
			]
		] ifNil: [
			error := 'Username / Password does not exist'.
		]
	]

	renderContentOn: html [
		html heading level: 1;
					 with: 'Login'.
		error ifNotNil: [
			 html paragraph class: 'poll-error';
							with: error.
		].
		html form class: 'pure-form';
				  with: [
					html textInput callback: [ :value | username := value ];
								   attributeAt: 'placeholder' put: 'Username'.
					html passwordInput callback: [ :value | password := value ];
									   attributeAt: 'placeholder' put: 'Password'.
					html break.
					html submitButton callback: [ self login ];
								  value: 'Login';
								  class: 'pure-button pure-button-primary'
			]
	]
]
