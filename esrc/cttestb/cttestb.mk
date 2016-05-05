cttestb-empty: $(BIN_DIR)/cttestb.com

$(BIN_DIR)/cttestb.com:	tools $(BIN_DIR)/cttestb.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/cttestb

$(BIN_DIR)/cttestb.ihx:	libraries $(BIN_DIR)/cttestb.rel $(BIN_DIR)/cttestb.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/cttestb.arf

$(BIN_DIR)/cttestb.rel: $(ESRC_DIR)/cttestb/cttestb.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/cttestb/cttestb.c

$(BIN_DIR)/cttestb.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/cttestb/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/cttestb.arf 
