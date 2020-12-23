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
	@if [ $$check_fail != 0 ]; then \
		exit 1; \
	fi

$(LOG): $(BUILD_DIR)/%.log: $(TEST_DIR)/%.in $(EXEC)
	@check_fail=0; \
	@$(EXEC) $< >$@; \
	@if cmp -s $(TEST_DIR)/$*.out $@; then \
		echo Test $*   passed; \
	else \
		check_fail=$$(($$check_fail + 1)); \
		echo Test $*  failed; \
	fi

clean:
	rm -rf $(EXEC) $(OBJECT) $(LOG)