CANISTERS=blackhole
SRC=$(CANISTERS:%=src/%.mo)
OBJ=$(CANISTERS:%=dist/%.wasm)
OBJ_OPT=$(CANISTERS:%=dist/%-opt.wasm)
IDL=$(CANISTERS:%=dist/%.did)
MOC_OPT?=$(vessel sources)

build: $(OBJ) $(IDL) $(OBJ_OPT)

clean:
	rm -rf dist

dist:
	@mkdir -p $@

dist/%.wasm: src/%.mo | dist
	moc $(MOC_OPT) -o $@ $<

dist/%-opt.wasm: dist/%.wasm
	wasm-opt -O2 -o $@ $<

dist/%.did: src/%.mo | dist
	moc $(MOC_OPT) --idl -o $@ $<

dfx.json:
	@echo '{"canisters":{"blackhole":{"type":"custom","candid":"dist/blackhole.did","wasm":"dist/blackhole-opt.wasm","build":""}}}' > $@

.PHONY: build clean really-clean
