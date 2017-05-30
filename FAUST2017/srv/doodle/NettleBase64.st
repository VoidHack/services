DLD addLibrary: 'libnettle.so.4'.

CStruct subclass: NettleBase64Encode [
	<category: 'Nettle-C Base64 interface'>

	<declaration: #(
		(#word #uInt)
		(#bits #uInt)
	)>

	NettleBase64Encode class >> base64_encode_length: length [
		^(((length * 8 + 4)/6) floor)
	]

	NettleBase64Encode class >> base64_encode_raw_length: length [
		^((((length + 2)/3)*4) floor)
	]

	init [
		<cCall: 'nettle_base64_encode_init'
				returning: #void
				args: #(#self)>
	]

	base64_encode_single: dst src: src [
		<cCall: 'nettle_base64_encode_single'
				returning: #uInt
				args: #(#self #cObject #char)>
	]

	base64_encode_update: dst length: length src: src [
		<cCall: 'nettle_base64_encode_update'
				returning: #uInt
				args: #(#self #cObject #uInt #byteArray)>
	]

	base64_encode_final: dst [
		<cCall: 'nettle_base64_encode_final'
				returning: #uInt
				args: #(#self #cObject)>
	]

	NettleBase64Encode class >> base64_encode_raw: dst length: length src: src [
		<cCall: 'nettle_base64_encode_raw'
				returning: #void
				args: #(#cObject #uInt #byteArray)>
	]

	update: src [
		| result encodesize |

		encodesize := NettleBase64Encode base64_encode_length: (1 + (src size)).
		result := ByteArray new: encodesize.
		self base64_encode_update: result length: (src size) src: src.
		^(String fromCData: (result asCData)).
	]

	finalize [
		| result |

		result := ByteArray new: 4.
		self base64_encode_final: result.
		^(String fromCData: (result asCData)).
	]
]

CStruct subclass: NettleBase64Decode [
	<category: 'Nettle-C Base64 interface'>
	
	<declaration: #(
		(#word #uInt)
		(#bits #uInt)
		(#padding #uInt)
	)>

	NettleBase64Decode class >> base64_decode_length: length [
		^((((length + 1) * 6) / 8) floor)
	]

	init [
		<cCall: 'nettle_base64_decode_init'
				returning: #void
				args: #(#self)>
	]

	base64_decode_single: dst src: src [
		<cCall: 'nettle_base64_decode_single'
				returning: #uInt
				args: #(#self #cObject #char)>
	]

	base64_decode_update: dstlen dst: dst srclen: srclen src: src [
		<cCall: 'nettle_base64_decode_update'
				returning: #uInt
				args: #(#self (#ptr #uInt) #cObject #uInt #string)>
	]

	finalize [
		<cCall: 'nettle_base64_decode_final'
				returning: #uInt
				args: #(#self)>
	]

	update: data [
		| len lenptr buffer |

		len := NettleBase64Decode base64_decode_length: (data size).
		lenptr := CInt gcValue: len.
		buffer := ByteArray new: len.
		self base64_decode_update: lenptr dst: buffer srclen: (data size) src: data.
		^buffer.
	]
]
