dfbtest-empty: $(BIN_DIR)/dfbtest.com

$(BIN_DIR)/dfbtest.com:	tools $(BIN_DIR)/dfbtest.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/dfbtest

$(BIN_DIR)/dfbtest.ihx:	libraries $(BIN_DIR)/dfbtest.rel $(BIN_DIR)/dfbtest.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/dfbtest.arf

$(BIN_DIR)/dfbtest.rel: $(ESRC_DIR)/dfbtest/dfbtest.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/dfbtest/dfbtest.c

$(BIN_DIR)/dfbtest.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/dfbtest/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/dfbtest.arf 
