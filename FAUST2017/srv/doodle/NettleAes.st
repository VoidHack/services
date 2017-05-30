DLD addLibrary: 'libnettle.so.4'.

NettleSymmetricCipher subclass: NettleAes [
	<category: 'Nettle-C AES interface'>
	| decrypt |

	<declaration: #(
		(#keys (#array #uInt 60))
		(#nrounds #uLong)
	)>

	aes_set_encrypt_key: length key: key [
		<cCall: 'nettle_aes_set_encrypt_key'
				returning: #void
				args: #(#self #int #byteArray)>
	]

	aes_set_decrypt_key: length key: key [
		<cCall: 'nettle_aes_set_decrypt_key'
				returning: #void
				args: #(#self #int #byteArray)>
	]

	NettleAes class >> aes_invert_key: ctx src: src [
		<cCall: 'nettle_aes_invert_key'
				returning: #void
				args: #(#self #cObject)>
	]

	nettle_encrypt: length dst: dst src: src [
		<cCall: 'nettle_aes_encrypt'
				returning: #void
				args: #(#self #int #cObject #byteArray)>
	]

	nettle_decrypt: length dst: dst src: src [
		<cCall: 'nettle_aes_decrypt'
				returning: #void
				args: #(#self #int #cObject #byteArray)>
	]


	set_encrypt_key: key [
		self aes_set_encrypt_key: (key size) key: key
	]

	set_decrypt_key: key [
		self aes_set_decrypt_key: (key size) key: key
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
