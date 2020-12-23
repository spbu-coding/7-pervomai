#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT_STRING_SIZE 1000
#define MAX_OUTPUT_STRING_NUM 100

#define error(...) (fprintf(stderr, __VA_ARGS__))

int compare(const void* string_1, const void* string_2){
    return -strcmp(*(const char **)string_1,*(const char **)string_2);
}

int delete_symbols(char** strings_array, int count_str) {
    for (int k = 0; k < count_str; k++) {
        int lenght = (int)strlen(strings_array[k]);
        for (int i = 0; i < lenght; i++) {
            if (strings_array[k][i] == '!' || strings_array[k][i] == '?' || strings_array[k][i] == ';' || strings_array[k][i] == ':'
            || strings_array[k][i] == '.' || strings_array[k][i] == ',') {
                for (int j = i; j < lenght; j++) {
                    strings_array[k][j] = strings_array[k][j + 1];
                    strings_array[k][j + 1] = '\0';
                }
            }
        }
    }
    return 0;
}

void add_lf( char* string ){
    int i;
    for (i = 0; i < MAX_INPUT_STRING_SIZE && string[i] != '\n' && string[i] !='\0'; i++ ){
        i++;
    }
    string[i] = '\n';
}

int main(int argc, char* argv[]) {
    if (argc != 2){
        error("There must be 1 argument\n");
        return -1;
    }

    int count_str = 0;

    char** strings_array = (char**)malloc(sizeof(char*) * 1);
    if (strings_array == NULL) {
        error("Fail in allocation memory\n");
        return -1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (input_file == NULL) {
        error("Fail in opening input file\n");
        return -1;
    }

//READING FILE

    while (!feof(input_file)) {
        strings_array[count_str] = (char *) malloc(sizeof(char) * MAX_INPUT_STRING_SIZE);
        if (strings_array[count_str] == NULL){
            fclose(input_file);
            for(int i = 0; i < count_str; i++)
                free(strings_array[i]);
            free(strings_array);
            strings_array = NULL;
            error("Fail in allocation memory\n");
            return -1;
        }

        if (fgets(strings_array[count_str], MAX_INPUT_STRING_SIZE, input_file) == NULL) {
            error("Fail getting string from input file\n");
            return -1;
        }

        count_str++;

        strings_array = (char**)realloc(strings_array,sizeof(char*) * (count_str + 1));
        if (strings_array == NULL) {
            fclose(input_file);
            for(int i = 0; i < count_str; i++)
                free(strings_array[i]);
            free(strings_array);
            strings_array = NULL;
            error("Fail in allocation memory\n");
            return -1;
        }
    }

    add_lf(strings_array[count_str - 1]);
    delete_symbols(strings_array, count_str);
    qsort(strings_array, count_str, sizeof(char*), compare);

    for (int i = 0; i < MAX_OUTPUT_STRING_NUM && i < count_str; i++){
        printf("%s", strings_array[i]);
        }

    fclose(input_file);
    for(int i = 0; i < count_str; i++)
        free(strings_array[i]);
    free(strings_array);
    strings_array = NULL;

    return 0;
}