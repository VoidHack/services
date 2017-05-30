#!/usr/bin/make -f

GSTREMOTE ?= gst-remote
HASH = NettleRipeMd160.st NettleMd4.st NettleSha1.st NettleMd5.st NettleSha2.st
MAC = NettleHmac.st
PRIVKEY = NettleSymmetricCipher.st NettleAes.st NettleTwofish.st
SOURCES = $(HASH) $(MAC) $(PRIVKEY) NettleBase64.st NettleCbc.st
TESTS = $(wildcard tests/*.st)

build: $(SOURCES)
	$(GSTREMOTE) $(patsubst %,-f %,$(SOURCES))

check: $(SOURCES) $(TESTS)
	gst-sunit $(patsubst %,-f %,$(SOURCES) $(TESTS)) $(patsubst tests/%.st,%,$(TESTS))
