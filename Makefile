CANISTERS=blackhole
OBJ=$(CANISTERS:%=dist/%.wasm)
OBJ_OPT=$(CANISTERS:%=dist/%-opt.wasm)
IDL=$(CANISTERS:%=dist/%.did)

build: $(OBJ) $(IDL) $(OBJ_OPT)

clean:
	rm -rf dist

dist:
	@mkdir -p $@

dist/%.wasm: src/%.mo | dist
	moc -o $@ $<

dist/%-opt.wasm: dist/%.wasm
	wasm-opt -O2 -o $@ $<

dist/%.did: src/%.mo | dist
	moc --idl -o $@ $<

dfx.json:
	@echo '{"canisters":{"blackhole":{"type":"custom","candid":"dist/blackhole.did","wasm":"dist/blackhole-opt.wasm","build":""}}}' > $@

.PHONY: build clean really-clean
