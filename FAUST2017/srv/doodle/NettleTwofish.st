DLD addLibrary: 'libnettle.so.4'.

NettleSymmetricCipher subclass: NettleTwofish [
	<category: 'Nettle-C TWOFISH interface'>

	<declaration: #(
		(#keys (#array #uInt 40))
		(#s_box (#array (#array #uInt 256) 4))
	)>

	twofish_set_key: length key: key [
		<cCall: 'nettle_twofish_set_key'
				returning: #void
				args: #(#self #int #byteArray)>
	]

	nettle_encrypt: length dst: dst src: src [
		<cCall: 'nettle_twofish_encrypt'
				returning: #void
				args: #(#self #int #cObject #byteArray)>
	]

	nettle_decrypt: length dst: dst src: src [
		<cCall: 'nettle_twofish_decrypt'
				returning: #void
				args: #(#self #int #cObject #byteArray)>
	]

	set_key: key [
		self twofish_set_key: (key size) key: key
	]

	encrypt: data [
		| size result |
		size := data size.
		result := ByteArray new: size.
		self nettle_encrypt: size dst: result src: data.
		^result
	]

	decrypt: data [
		| size result |
		size := data size.
		result := ByteArray new: size.
		self nettle_decrypt: size dst: result src: data.
		^result
	]
]
