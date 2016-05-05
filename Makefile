include common.mk

all: tools libraries examples \
	ymr-empty asmtest-empty boopoaat-empty cttesta-empty cttestb-empty cttestc-empty i135-empty o135-empty

#boopaao-empty

clean:	tools-clean libraries-clean examples-clean 
	rm -f $(BIN_DIR)/*

include tools.mk # Local tools
include libraries.mk # Libraries
include examples.mk # Examples

include esrc/ymr/ymr.mk
include esrc/asmtest/asmtest.mk
include esrc/boopoaat/boopoaat.mk
#include esrc/boopaao/boopaao.mk
include esrc/cttesta/cttesta.mk
include esrc/cttestb/cttestb.mk
include esrc/cttestc/cttestc.mk
include esrc/i135/i135.mk
include esrc/o135/o135.mk

