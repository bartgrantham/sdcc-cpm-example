cttesta-empty: $(BIN_DIR)/cttesta.com

$(BIN_DIR)/cttesta.com:	tools $(BIN_DIR)/cttesta.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/cttesta

$(BIN_DIR)/cttesta.ihx:	libraries $(BIN_DIR)/cttesta.rel $(BIN_DIR)/cttesta.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/cttesta.arf

$(BIN_DIR)/cttesta.rel: $(ESRC_DIR)/cttesta/cttesta.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/cttesta/cttesta.c

$(BIN_DIR)/cttesta.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/cttesta/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/cttesta.arf 
