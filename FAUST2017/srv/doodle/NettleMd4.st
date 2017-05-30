DLD addLibrary: 'libnettle.so.4'.

CStruct subclass: NettleMd4 [
	<category: 'Nettle-C MD4 interface'>

	<declaration: #(
		(#state (#array #uInt 4))
		(#count_low #uInt)
		(#count_high #uInt)
		(#block (#array #uChar 64))
		(#index #uLong)
	)>

	init [
		<cCall: 'nettle_md4_init'
				returning: #void
				args: #(#self)>
	]

	md4_update: length data: data [
		<cCall: 'nettle_md4_update'
				returning: #void
				args: #(#self #uInt #byteArray)>
	]

	md4_digest: length digest: digest [
		<cCall: 'nettle_md4_digest'
				returning: #void
				args: #(#self #uInt #cObject)>
	]

	update: data [
		self md4_update: (data size) data: data.
	]

	digest [
		| result |
		result := ByteArray new: 16.
		self md4_digest: 16 digest: result.
		^result
	]
]