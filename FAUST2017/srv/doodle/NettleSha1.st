DLD addLibrary: 'libnettle.so.4'.

CStruct subclass: NettleSha1 [
	<category: 'Nettle-C SHA1 interface'>

	<declaration: #(
		(#state (#array #uInt 5))
		(#count_low #uInt)
		(#count_high #uInt)
		(#block (#array #uChar 64))
		(#index #uLong)
	)>

	init [
		<cCall: 'nettle_sha1_init'
				returning: #void
				args: #(#self)>
	]

	sha1_update: length data: data [
		<cCall: 'nettle_sha1_update'
				returning: #void
				args: #(#self #uInt #byteArray)>
	]

	sha1_digest: length digest: digest [
		<cCall: 'nettle_sha1_digest'
				returning: #void
				args: #(#self #uInt #cObject)>
	]

	update: data [
		self sha1_update: (data size) data: data.
	]

	digest [
		| result |
		result := ByteArray new: 20.
		self sha1_digest: 20 digest: result.
		^result
	]
]