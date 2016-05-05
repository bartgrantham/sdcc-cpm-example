i135-empty: $(BIN_DIR)/i135.com

$(BIN_DIR)/i135.com:	tools $(BIN_DIR)/i135.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/i135

$(BIN_DIR)/i135.ihx:	libraries $(BIN_DIR)/i135.rel $(BIN_DIR)/i135.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/i135.arf

$(BIN_DIR)/i135.rel: $(ESRC_DIR)/i135/i135.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/i135/i135.c

$(BIN_DIR)/i135.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/i135/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/i135.arf 
