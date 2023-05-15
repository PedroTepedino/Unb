#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>


int dbc2dbf(FILE* input, FILE* output)
{
    int read = 0;
    int err = 0;

    uint16_t header= 0;

    unsigned char rawHeader[2];

    read = fseek(input, 8, SEEK_SET);
    err = ferror(input);
    printf("read: %d - error: %d\n", read, err);

    read = fread(rawHeader, 2, 1, input);
    err = ferror(input);
    printf("read: %d - error: %d\n", read, err);

    printf("%X  %X\n", rawHeader[0], rawHeader[1]);

    header = rawHeader[0] + (rawHeader[1] << 8);

    printf("%X -- %u\n", header, header);

    read = fseek(input, 0, SEEK_SET);
    err = ferror(input);
    printf("read: %d - error: %d\n", read, err);

    unsigned char buf[header];
    
    read = fread(buf, 1, header, input);
    err = ferror(input);
    printf("read: %d - error: %d\n", read, err);
    buf [header - 1] = 0X0D;
    read = fwrite(buf, 1, header, output);
    err = ferror(input);



    return 0;
}

void help(char* prog_name){
    fprintf(stderr, "Syntax error!\n");
    fprintf(stderr, "\tUsage: %s input.dbc output.dbf\n", prog_name);
}

int main(int argc, char **argv)
{
    int ret;
    FILE *input, *output;

    if (argc == 3)
    {
        input = fopen(argv[1], "rb");
        output = fopen(argv[2], "wb");
    }
    else if (isatty(STDIN_FILENO))
    {
        help(argv[0]);
        exit(1);
    }
    else
    {
        input = stdin;
        output = stdout;
    }

    ret = dbc2dbf(input, output);

    fclose(input);
    fclose(output);
    return 0;
}
