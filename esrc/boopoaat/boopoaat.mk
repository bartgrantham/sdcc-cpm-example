boopoaat-empty: $(BIN_DIR)/boopoaat.com

$(BIN_DIR)/boopoaat.com:	tools $(BIN_DIR)/boopoaat.ihx
	$(LBIN_DIR)/load $(BIN_DIR)/boopoaat

$(BIN_DIR)/boopoaat.ihx:	libraries $(BIN_DIR)/boopoaat.rel $(BIN_DIR)/boopoaat.arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/boopoaat.arf

$(BIN_DIR)/boopoaat.rel: $(ESRC_DIR)/boopoaat/boopoaat.c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/boopoaat/boopoaat.c

$(BIN_DIR)/boopoaat.arf:	$(BIN_DIR)/generic.arf
	$(QUIET)$(SED) 's/$(REPLACE_TAG)/boopoaat/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/boopoaat.arf 
