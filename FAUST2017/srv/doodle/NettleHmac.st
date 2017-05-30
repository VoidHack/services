DLD addLibrary: 'libnettle.so.4'.

CStruct subclass: NettleHmacSha1 [
	<category: 'Nettle-C HMAC-SHA1 interface'>

	<declaration: #(
		(#outer #{NettleSha1})
		(#inner #{NettleSha1})
		(#state #{NettleSha1})
	)>

	hmac_set_key: length key: key [
		<cCall: 'nettle_hmac_sha1_set_key'
				returning: #void
				args: #(#self #uInt #byteArray)>
	]

	hmac_update: length data: data [
		<cCall: 'nettle_hmac_sha1_update'
				returning: #void
				args: #(#self #uInt #byteArray)>
	]

	hmac_digest: length digest: digest [
		<cCall: 'nettle_hmac_sha1_digest'
				returning: #void
				args: #(#self #uInt #cObject)>
	]


	set_key: key [
		self hmac_set_key: (key size) key: key.
	]

	update: data [
		self hmac_update: (data size) data: data.
	]

	digest [
		| result |
		result := ByteArray new: 20.
		self hmac_digest: 20 digest: result.
		^result
	]

]
