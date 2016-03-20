ym-empty: $(BIN_DIR)/ym.com

$(BIN_DIR)/ym.com:	tools $(BIN_DIR)/ym.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/ym

$(BIN_DIR)/ym.ihx:	libraries $(BIN_DIR)/ym.rel $(BIN_DIR)/ym.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/ym.arf

$(BIN_DIR)/ym.rel: $(ESRC_DIR)/ym/ym.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/ym/ym.c

$(BIN_DIR)/ym.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/ym/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/ym.arf 
