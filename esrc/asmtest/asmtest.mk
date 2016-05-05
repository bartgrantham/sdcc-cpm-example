asmtest-empty: $(BIN_DIR)/asmtest.com

$(BIN_DIR)/asmtest.com:	tools $(BIN_DIR)/asmtest.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/asmtest

$(BIN_DIR)/asmtest.ihx:	libraries $(BIN_DIR)/asmtest.rel $(BIN_DIR)/asmtest.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/asmtest.arf

$(BIN_DIR)/asmtest.rel: $(ESRC_DIR)/asmtest/asmtest.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/asmtest/asmtest.c

$(BIN_DIR)/asmtest.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/asmtest/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/asmtest.arf 
