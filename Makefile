include CONFIG.cfg
CC = gcc
LD = gcc
EXEC = $(BUILD_DIR)/$(NAME)
OBJECT = $(BUILD_DIR)/main.o
LOG = $(wildcard $(TEST_DIR)/*.in: $(TEST_DIR)/%.in=$(BUILD_DIR)/%.log)

.PHONY: all check clean

all: $(EXEC)

$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c | $(BUILD_DIR)
	$(CC) -c $< -o $@

$(EXEC): $(OBJECT)
	$(LD) $^ -o $@
	
$(BUILD_DIR):
	mkdir -p $@

check: $(LOG)

$(BUILD_DIR)/%.log: $(TEST_DIR)/%.in $(EXEC)
	@$(EXEC) $< >$@; \
	@if cmp -s $(TEST_DIR)/$*.out $@; then \
		echo Test $*	passed; \
	else \
		echo "Test $*	failed" ; \
		exit 1 ;  \
	fi

clean:
	rm -rf $(EXEC) $(OBJECT) $(LOG)