CANISTERS=blackhole
SRC=$(CANISTERS:%=src/%.mo)
OBJ=$(CANISTERS:%=dist/%.wasm)
OBJ_OPT=$(CANISTERS:%=dist/%-opt.wasm)
IDL=$(CANISTERS:%=dist/%.did)
MOC_OPT?=$(vessel sources)

dfx.json:
	@echo '{}' > $@

build: $(OBJ) $(IDL) $(OBJ_OPT)

clean:
	rm -f dist

dist:
	@mkdir -p $@

dist/%.wasm: src/%.mo | dist
	moc $(MOC_OPT) -o $@ $<

dist/%.did: src/%.mo | dist
	moc $(MOC_OPT) --idl -o $@ $<

.PHONY: build clean really-clean

UTIL_DIR?=/nix/store/4gaariri115lys3l5mfip6knn0v78clp-ic-utils
include $(UTIL_DIR)/share/mk/inc.mk
