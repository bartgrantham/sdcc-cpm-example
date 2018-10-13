PROGRAM = minboop

$(PROGRAM)-empty: $(BIN_DIR)/$(PROGRAM).com

$(BIN_DIR)/$(PROGRAM).com:	tools $(BIN_DIR)/$(PROGRAM).ihx
	$(LBIN_DIR)/load $(BIN_DIR)/$(PROGRAM)

$(BIN_DIR)/$(PROGRAM).ihx:	libraries $(BIN_DIR)/$(PROGRAM).rel $(BIN_DIR)/$(PROGRAM).arf 
	$(CLD) $(CLD_FLAGS) -nf $(BIN_DIR)/$(PROGRAM).arf

$(BIN_DIR)/$(PROGRAM).rel: $(ESRC_DIR)/$(PROGRAM)/$(PROGRAM).c
	$(CCC) $(CCC_FLAGS) -o $(BIN_DIR) $(ESRC_DIR)/$(PROGRAM)/$(PROGRAM).c

$(BIN_DIR)/$(PROGRAM).arf:	$(BIN_DIR)/generic.arf
	$(SED) 's/$(REPLACE_TAG)/$(PROGRAM)/' $(BIN_DIR)/generic.arf > $(BIN_DIR)/$(PROGRAM).arf 
