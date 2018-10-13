include common.mk

all: tools libraries examples \
	ymr-empty asmtest-empty boopaao-empty boopoaat-empty cttesta-empty cttestb-empty cttestc-empty i135-empty o135-empty cpmenv-empty cpuspeed-empty dfbtest-empty minboop-empty

clean:	tools-clean libraries-clean examples-clean 
	rm -f $(BIN_DIR)/*

include tools.mk # Local tools
include libraries.mk # Libraries
include examples.mk # Examples

include esrc/*/*.mk  # Our programs
