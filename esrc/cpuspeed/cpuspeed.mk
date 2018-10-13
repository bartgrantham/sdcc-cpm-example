cpuspeed-empty: $(BIN_DIR)/cpuspeed.com

$(BIN_DIR)/cpuspeed.com:	tools $(BIN_DIR)/cpuspeed.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/cpuspeed

$(BIN_DIR)/cpuspeed.ihx:	libraries $(BIN_DIR)/cpuspeed.rel $(BIN_DIR)/cpuspeed.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/cpuspeed.arf

$(BIN_DIR)/cpuspeed.rel: $(ESRC_DIR)/cpuspeed/cpuspeed.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/cpuspeed/cpuspeed.c

$(BIN_DIR)/cpuspeed.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/cpuspeed/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/cpuspeed.arf 
