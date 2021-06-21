BIN = cnda

all: $(BIN)

cnda: cnda.nim args.nim envs.nim
	nim compile cnda.nim

clean:
	rm -f $(BIN)
