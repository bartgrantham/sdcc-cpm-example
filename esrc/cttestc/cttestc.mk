cttestc-empty: $(BIN_DIR)/cttestc.com

$(BIN_DIR)/cttestc.com:	tools $(BIN_DIR)/cttestc.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/cttestc

$(BIN_DIR)/cttestc.ihx:	libraries $(BIN_DIR)/cttestc.rel $(BIN_DIR)/cttestc.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/cttestc.arf

$(BIN_DIR)/cttestc.rel: $(ESRC_DIR)/cttestc/cttestc.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/cttestc/cttestc.c

$(BIN_DIR)/cttestc.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/cttestc/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/cttestc.arf 
