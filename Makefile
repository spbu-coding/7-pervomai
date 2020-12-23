include CONFIG.cfg

CC = gcc
LD = gcc

CHECK_OK = ok
CHECK_FAIL = fail

EXEC = $(BUILD_DIR)/$(NAME)
OBJECT = $(BUILD_DIR)/main.o
LOG = $(patsubst $(TEST_DIR)/%.in, $(TEST_DIR)/%.log, $(wildcard $(TEST_DIR)/*.in))

.PHONY: all clean check

all: $(EXEC)


$(EXEC): $(OBJECT)

	$(LD) $(LDFLAGS) $^ -o $@


$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c | $(BUILD_DIR)

	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@	


$(BUILD_DIR):

	mkdir -p $@


check: $(LOGS)

	@for log in $^ ; do \
        if [ "$$(cat $${log})" != "$(CHECK_OK)" ]; then \
            	exit 1; \
        fi; \
    done


$(TEST_DIR)/%.log: $(TEST_DIR)/%.in $(TEST_DIR)/%.out $(EXE)

	@if [ "$$(./$(EXE) ./$<)" = "$$(cat $(word 2, $^))" ]; then \
	echo "Test $< passed"; \
        echo "$(CHECK_OK)" > $@; \
    else \
    	echo "Test $< failed"; \
        echo "$(CHECK_FAIL)" > $@; \
	fi


clean:
	$(RM) $(EXEC) $(OBJECT) $(LOG)