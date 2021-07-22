BIN = cnda

all: $(BIN)

cnda: cnda.nim args.nim envs.nim activate.nim create.nim remove.nim completions.nim
# below command generates a smaller binary
#	nim compile -d:release --opt:size cnda.nim
	nim compile cnda.nim

clean:
	rm -f $(BIN)
