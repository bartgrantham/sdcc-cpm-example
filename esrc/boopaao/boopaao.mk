boopaao-empty: $(BIN_DIR)/boopaao.com

$(BIN_DIR)/boopaao.com:	tools $(BIN_DIR)/boopaao.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/boopaao

$(BIN_DIR)/boopaao.ihx:	libraries $(BIN_DIR)/boopaao.rel $(BIN_DIR)/boopaao.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/boopaao.arf

$(BIN_DIR)/boopaao.rel: $(ESRC_DIR)/boopaao/boopaao.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/boopaao/boopaao.c

$(BIN_DIR)/boopaao.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/boopaao/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/boopaao.arf 
