DLD addLibrary: 'libnettle.so.4'.

Object subclass: NettleCbc [
	<category: 'Nettle-C CBC interface'>
	| context iv blocksize |

	iv [
		^iv
	]

	iv: aIv [
		iv := aIv
	]

	context [
		^context
	]

	context: aContext [
		context := aContext.
		blocksize := self blocksize.
	]

	pad: data [
		| padlen padding |

		padlen := blocksize - ((data size) rem: blocksize).
		(padlen < blocksize) ifTrue: [
			padding := ByteArray new: padlen.
			^(data, padding)
		] ifFalse: [
			^data
		]
	]

	encrypt: data [
		^(self real_encrypt: (self pad: data))
	]

	decrypt: data [
		^(self real_decrypt: (self pad: data))
	]

	real_encrypt: data [
	]
	real_decrypt: data [
	]
	blocksize [
	]

	NettleCbc class >> cbc_encrypt: ctx func: func blocksize: blocksize iv: iv length: length dst: dst src: src [
		<cCall: 'nettle_cbc_encrypt'
				returning: #void
				args: #(#cObject #cObject #uInt #byteArray #uInt #cObject #byteArray)>
	]

	NettleCbc class >> cbc_decrypt: ctx func: func blocksize: blocksize iv: iv length: length dst: dst src: src [
		<cCall: 'nettle_cbc_decrypt'
				returning: #void
				args: #(#cObject #cObject #uInt #byteArray #uInt #cObject #byteArray)>
	]
]

NettleCbc subclass: NettleAesCbc [
	blocksize [ ^16 ]

	real_encrypt: data [
		| size result |

		size := data size.
		result := ByteArray new: size.

		NettleCbc cbc_encrypt: context
					  func: (CCallbackDescriptor
							   for: [ :ctx :length :dst :src | ctx nettle_encrypt: length dst: dst src: (ByteArray fromCData: src size: length) ]
							   returning: #void
							   withArgs: #(#{NettleAes} #int #cObject #cObject))
					  blocksize: 16
					  iv: iv
					  length: size
					  dst: result
					  src: data.
		^result
	]

	real_decrypt: data [
		| size result |

		size := data size.
		result := ByteArray new: size.

		NettleCbc cbc_decrypt: context
					  func: (CCallbackDescriptor
							   for: [ :ctx :length :dst :src | ctx nettle_decrypt: length dst: dst src: (ByteArray fromCData: src size: length) ]
							   returning: #void
							   withArgs: #(#{NettleAes} #int #cObject #cObject))
					  blocksize: 16
					  iv: iv
					  length: size
					  dst: result
					  src: data.
		^result
	]

]

NettleCbc subclass: NettleTwofishCbc [
	blocksize [ ^16 ]

	real_encrypt: data [
		| size result |

		size := data size.
		result := ByteArray new: size.

		NettleCbc cbc_encrypt: context
					  func: (CCallbackDescriptor
							   for: [ :ctx :length :dst :src | ctx nettle_encrypt: length dst: dst src: (ByteArray fromCData: src size: length) ]
							   returning: #void
							   withArgs: #(#{NettleTwofish} #int #cObject #cObject))
					  blocksize: 16
					  iv: iv
					  length: size
					  dst: result
					  src: data.
		^result
	]

	real_decrypt: data [
		| size result |

		size := data size.
		result := ByteArray new: size.

		NettleCbc cbc_decrypt: context
					  func: (CCallbackDescriptor
							   for: [ :ctx :length :dst :src | ctx nettle_decrypt: length dst: dst src: (ByteArray fromCData: src size: length) ]
							   returning: #void
							   withArgs: #(#{NettleTwofish} #int #cObject #cObject))
					  blocksize: 16
					  iv: iv
					  length: size
					  dst: result
					  src: data.
		^result
	]

]
