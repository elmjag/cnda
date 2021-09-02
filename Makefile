BIN = cnda setup
INSTALLER = cnda-0.0.0.run

COMPILE_FLAGS =
# below compile flags generates a smaller binary
#COMPILE_FLAGS = -d:release --opt:size

all: $(BIN)

cnda: cnda.nim args.nim envs.nim misc.nim create.nim remove.nim completions.nim
	nim compile $(COMPILE_FLAGS) cnda.nim

setup: setup.nim
	nim compile $(COMPILE_FLAGS) setup.nim


clean:
	rm -f $(BIN) $(INSTALLER)

installer: cnda setup
	mkarchive --libtar /usr/lib/libtar.a --output $(INSTALLER) $^
