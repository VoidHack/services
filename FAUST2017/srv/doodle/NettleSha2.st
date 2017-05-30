DLD addLibrary: 'libnettle.so.4'.

CStruct subclass: NettleSha224 [
	<category: 'Nettle-C SHA224 interface'>

	<declaration: #(
		(#state (#array #uInt 8))
		(#count_low #uInt)
		(#count_high #uInt)
		(#block (#array #uChar 64))
		(#index #uLong)
	)>

	init [
		<cCall: 'nettle_sha224_init'
				returning: #void
				args: #(#self)>
	]

	sha224_update: length data: data [
		<cCall: 'nettle_sha256_update'
				returning: #void
				args: #(#self #uInt #byteArray)>
	]

	sha224_digest: length digest: digest [
		<cCall: 'nettle_sha256_digest'
				returning: #void
				args: #(#self #uInt #cObject)>
	]

	update: data [
		self sha224_update: (data size) data: data.
	]

	digest [
		| result |
		result := ByteArray new: 28.
		self sha224_digest: 28 digest: result.
		^result
	]
]

CStruct subclass: NettleSha256 [
	<category: 'Nettle-C SHA256 interface'>

	<declaration: #(
		(#state (#array #uInt 8))
		(#count_low #uInt)
		(#count_high #uInt)
		(#block (#array #uChar 64))
		(#index #uLong)
	)>

	init [
		<cCall: 'nettle_sha256_init'
				returning: #void
				args: #(#self)>
	]

	sha256_update: length data: data [
		<cCall: 'nettle_sha256_update'
				returning: #void
				args: #(#self #uInt #byteArray)>
	]

	sha256_digest: length digest: digest [
		<cCall: 'nettle_sha256_digest'
				returning: #void
				args: #(#self #uInt #cObject)>
	]

	update: data [
		self sha256_update: (data size) data: data.
	]

	digest [
		| result |
		result := ByteArray new: 32.
		self sha256_digest: 32 digest: result.
		^result
	]
]

CStruct subclass: NettleSha384 [
	<category: 'Nettle-C SHA384 interface'>

	<declaration: #(
		(#state (#array #uLong 8))
		(#count_low #uLong)
		(#count_high #uLong)
		(#block (#array #uChar 128))
		(#index #uLong)
	)>

	init [
		<cCall: 'nettle_sha384_init'
				returning: #void
				args: #(#self)>
	]

	sha384_update: length data: data [
		<cCall: 'nettle_sha512_update'
				returning: #void
				args: #(#self #uInt #byteArray)>
	]

	sha384_digest: length digest: digest [
		<cCall: 'nettle_sha512_digest'
				returning: #void
				args: #(#self #uInt #cObject)>
	]

	update: data [
		self sha384_update: (data size) data: data.
	]

	digest [
		| result |
		result := ByteArray new: 48.
		self sha384_digest: 48 digest: result.
		^result
	]
]

CStruct subclass: NettleSha512 [
	<category: 'Nettle-C SHA512 interface'>

	<declaration: #(
		(#state (#array #uLong 8))
		(#count_low #uLong)
		(#count_high #uLong)
		(#block (#array #uChar 128))
		(#index #uLong)
	)>

	init [
		<cCall: 'nettle_sha512_init'
				returning: #void
				args: #(#self)>
	]

	sha512_update: length data: data [
		<cCall: 'nettle_sha512_update'
				returning: #void
				args: #(#self #uInt #byteArray)>
	]

	sha512_digest: length digest: digest [
		<cCall: 'nettle_sha512_digest'
				returning: #void
				args: #(#self #uInt #cObject)>
	]

	update: data [
		self sha512_update: (data size) data: data.
	]

	digest [
		| result |
		result := ByteArray new: 64.
		self sha512_digest: 64 digest: result.
		^result
	]
]