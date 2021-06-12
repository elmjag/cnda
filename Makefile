BIN = cnda

all: $(BIN)

cnda: cnda.nim args.nim
	nim compile cnda.nim

clean:
	rm -f $(BIN)
