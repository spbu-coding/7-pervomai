include CONFIG.cfg
CC = gcc
LD = gcc
CHECK_OK = ok
CHECK_FAIL = fail
EXEC = $(BUILD_DIR)/$(NAME)
OBJECT = $(BUILD_DIR)/main.o
LOG = $(wildcard $(TEST_DIR)/*.in: $(TEST_DIR)/%.in=$(TEST_DIR)/%.log)

.PHONY: all check clean

all: $(EXEC)

$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c | $(BUILD_DIR)
	$(CC) -c $< -o $@

$(EXEC): $(OBJECT)
	$(LD) $^ -o $@
	
$(BUILD_DIR):
	mkdir -p $@

check: $(LOG)
	@for test in $^ ; do \
	if [ "$$(cat $$(test))" != "$(CHECK_OK)" ] ; then \
		exit 1 ; \
	fi ; \
	done

$(TEST_DIR)/%.log: $(TEST_DIR)/%.in $(TEST_DIR)/%.out $(EXEC)
	@if [ "$$(./$(EXEC) ./$<)" = "$$(cat $$(TEST_DIR)/%.out)" ] ; then \
	echo "$(CHECK_OK)" > $@ ; \
	echo "Test $<	passed" ; \
    else \
	echo "$(CHECK_FAIL)" > $@ ; \
	echo "Test $<	failed" ; \
    fi

clean:
	rm -rf $(EXEC) $(OBJECT) $(LOG)