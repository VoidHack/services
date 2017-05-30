DLD addLibrary: 'libnettle.so.4'.

CStruct subclass: NettleRipeMd160 [
	<category: 'Nettle-C RIPEMD160 interface'>

	<declaration: #(
		(#state (#array #uInt 5))
		(#count_low #uInt)
		(#count_high #uInt)
		(#block (#array #uChar 64))
		(#index #uLong)
	)>

	init [
		<cCall: 'nettle_ripemd160_init'
				returning: #void
				args: #(#self)>
	]

	ripemd160_update: length data: data [
		<cCall: 'nettle_ripemd160_update'
				returning: #void
				args: #(#self #uInt #byteArray)>
	]

	ripemd160_digest: length digest: digest [
		<cCall: 'nettle_ripemd160_digest'
				returning: #void
				args: #(#self #uInt #cObject)>
	]

	update: data [
		self ripemd160_update: (data size) data: data.
	]

	digest [
		| result |
		result := ByteArray new: 20.
		self ripemd160_digest: 20 digest: result.
		^result
	]
]