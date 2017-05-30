DLD addLibrary: 'libnettle.so.4'.

CStruct subclass: NettleMd5 [
	<category: 'Nettle-C MD5 interface'>

	<declaration: #(
		(#state (#array #uInt 4))
		(#count_low #uInt)
		(#count_high #uInt)
		(#block (#array #uChar 64))
		(#index #uLong)
	)>

	init [
		<cCall: 'nettle_md5_init'
				returning: #void
				args: #(#self)>
	]

	md5_update: length data: data [
		<cCall: 'nettle_md5_update'
				returning: #void
				args: #(#self #uInt #byteArray)>
	]

	md5_digest: length digest: digest [
		<cCall: 'nettle_md5_digest'
				returning: #void
				args: #(#self #uInt #cObject)>
	]


	update: data [
		self md5_update: (data size) data: data.
	]

	digest [
		| result |
		result := ByteArray new: 16.
		self md5_digest: 16 digest: result.
		^result
	]

]