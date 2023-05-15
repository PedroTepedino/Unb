#include <string>
#include <vector>


struct col
{
    std::string descriptor;
    char fieldType;
    int fieldSize;
    int filedDecimal;
    std::vector<std::string> data;
};