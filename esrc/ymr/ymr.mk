ymr-empty: $(BIN_DIR)/ymr.com

$(BIN_DIR)/ymr.com:	tools $(BIN_DIR)/ymr.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/ymr

$(BIN_DIR)/ymr.ihx:	libraries $(BIN_DIR)/ymr.rel $(BIN_DIR)/ymr.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/ymr.arf

$(BIN_DIR)/ymr.rel: $(ESRC_DIR)/ymr/ymr.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/ymr/ymr.c

$(BIN_DIR)/ymr.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/ymr/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/ymr.arf 
