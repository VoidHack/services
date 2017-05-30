DLD addLibrary: 'libnettle.so.4'.

CStruct subclass: NettleSymmetricCipher [
	nettle_encrypt: length dst: dst src: src [
	]

	nettle_decrypt: length dst: dst src: src [
	]
]