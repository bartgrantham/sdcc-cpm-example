cpmenv-empty: $(BIN_DIR)/cpmenv.com

$(BIN_DIR)/cpmenv.com:	tools $(BIN_DIR)/cpmenv.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/cpmenv

$(BIN_DIR)/cpmenv.ihx:	libraries $(BIN_DIR)/cpmenv.rel $(BIN_DIR)/cpmenv.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/cpmenv.arf

$(BIN_DIR)/cpmenv.rel: $(ESRC_DIR)/cpmenv/cpmenv.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/cpmenv/cpmenv.c

$(BIN_DIR)/cpmenv.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/cpmenv/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/cpmenv.arf 
