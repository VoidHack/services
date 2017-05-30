
Object subclass: Token [
	| iv ciphertext mac tokentype tokenvalue |

	tokenvalue: aTokenvalue [
		tokenvalue := aTokenvalue
	]

	tokenvalue [
		^tokenvalue
	]
	
	validate [
		| ctx cbc mctx enckey hmackey |

		hmackey := FileStream open: 'hmac.key'.
		enckey := FileStream open: 'enc.key'.

		mctx := NettleHmacSha1 new.
		mctx set_key: (hmackey nextByteArray: 16).
		mctx update: ciphertext.

		(mctx digest = mac) ifTrue: [
			ctx := NettleTwofish new.
			ctx set_key: (enckey nextByteArray: 16).
			cbc := NettleTwofishCbc new.
			
			cbc iv: iv.
			cbc context: ctx.
			tokenvalue := cbc decrypt: ciphertext.
			tokenvalue := (String fromCData: (tokenvalue asCData)).
		].
	]

	cryptography [
		| ctx cbc mctx rnd enckey hmackey |

		<comment: 'Encrypt-Then-Mac, see http://cseweb.ucsd.edu/~mihir/papers/oem.html'>

		hmackey := FileStream open: 'hmac.key'.
		enckey := FileStream open: 'enc.key'.

		ctx := NettleTwofish new.
		ctx set_key: (enckey nextByteArray: 16).
		cbc := NettleTwofishCbc new.

		rnd := FileStream open: '/dev/urandom'.
		rnd next.
		iv := rnd nextByteArray: 16.
		cbc iv: iv.
		cbc context: ctx.
		ciphertext := cbc encrypt: tokenvalue.

		mctx := NettleHmacSha1 new.
		mctx set_key: (hmackey nextByteArray: 16).
		mctx update: ciphertext.
		mac := mctx digest.
	]

	serialize [
		| b64 result |
		
		b64 :=NettleBase64Encode new.
		b64 init.
		result := b64 update: mac.
		result := result, (b64 update: iv).
		result := result, (b64 update: ciphertext).
		^(result, b64 finalize).
	]

	deserialize: data [
		| b64 buffer |

		b64 := NettleBase64Decode new.
		b64 init.

		buffer := b64 update: data.
		b64 finalize.

		mac := buffer copyFrom: 1 to: 20.
		iv := buffer copyFrom: 21 to: 36.

		ciphertext := buffer copyFrom: 37 to: ((buffer size)).
	]
]

Token subclass: PollToken [

]

Token subclass: AdminToken [

]

Token subclass: UserToken [

]
