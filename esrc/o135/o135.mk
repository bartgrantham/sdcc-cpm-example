o135-empty: $(BIN_DIR)/o135.com

$(BIN_DIR)/o135.com:	tools $(BIN_DIR)/o135.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/o135

$(BIN_DIR)/o135.ihx:	libraries $(BIN_DIR)/o135.rel $(BIN_DIR)/o135.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/o135.arf

$(BIN_DIR)/o135.rel: $(ESRC_DIR)/o135/o135.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/o135/o135.c

$(BIN_DIR)/o135.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/o135/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/o135.arf 
