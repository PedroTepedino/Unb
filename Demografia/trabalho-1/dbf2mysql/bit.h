#include <iostream>
#include <bitset>
#include <string>
#include <iomanip>

typedef unsigned char uchar;

const uchar revertByteTable[] = {
    0X00, 0X80, 0X40, 0XC0, 0X20, 0XA0, 0X60, 0XE0, 0X10, 0X90, 0X50, 0XD0, 0X30, 0XB0, 0X70, 0XF0, 
    0X08, 0X88, 0X48, 0XC8, 0X28, 0XA8, 0X68, 0XE8, 0X18, 0X98, 0X58, 0XD8, 0X38, 0XB8, 0X78, 0XF8, 
    0X04, 0X84, 0X44, 0XC4, 0X24, 0XA4, 0X64, 0XE4, 0X14, 0X94, 0X54, 0XD4, 0X34, 0XB4, 0X74, 0XF4, 
    0X0C, 0X8C, 0X4C, 0XCC, 0X2C, 0XAC, 0X6C, 0XEC, 0X1C, 0X9C, 0X5C, 0XDC, 0X3C, 0XBC, 0X7C, 0XFC, 
    0X02, 0X82, 0X42, 0XC2, 0X22, 0XA2, 0X62, 0XE2, 0X12, 0X92, 0X52, 0XD2, 0X32, 0XB2, 0X72, 0XF2, 
    0X0A, 0X8A, 0X4A, 0XCA, 0X2A, 0XAA, 0X6A, 0XEA, 0X1A, 0X9A, 0X5A, 0XDA, 0X3A, 0XBA, 0X7A, 0XFA, 
    0X06, 0X86, 0X46, 0XC6, 0X26, 0XA6, 0X66, 0XE6, 0X16, 0X96, 0X56, 0XD6, 0X36, 0XB6, 0X76, 0XF6, 
    0X0E, 0X8E, 0X4E, 0XCE, 0X2E, 0XAE, 0X6E, 0XEE, 0X1E, 0X9E, 0X5E, 0XDE, 0X3E, 0XBE, 0X7E, 0XFE, 
    0X01, 0X81, 0X41, 0XC1, 0X21, 0XA1, 0X61, 0XE1, 0X11, 0X91, 0X51, 0XD1, 0X31, 0XB1, 0X71, 0XF1, 
    0X09, 0X89, 0X49, 0XC9, 0X29, 0XA9, 0X69, 0XE9, 0X19, 0X99, 0X59, 0XD9, 0X39, 0XB9, 0X79, 0XF9, 
    0X05, 0X85, 0X45, 0XC5, 0X25, 0XA5, 0X65, 0XE5, 0X15, 0X95, 0X55, 0XD5, 0X35, 0XB5, 0X75, 0XF5, 
    0X0D, 0X8D, 0X4D, 0XCD, 0X2D, 0XAD, 0X6D, 0XED, 0X1D, 0X9D, 0X5D, 0XDD, 0X3D, 0XBD, 0X7D, 0XFD, 
    0X03, 0X83, 0X43, 0XC3, 0X23, 0XA3, 0X63, 0XE3, 0X13, 0X93, 0X53, 0XD3, 0X33, 0XB3, 0X73, 0XF3, 
    0X0B, 0X8B, 0X4B, 0XCB, 0X2B, 0XAB, 0X6B, 0XEB, 0X1B, 0X9B, 0X5B, 0XDB, 0X3B, 0XBB, 0X7B, 0XFB, 
    0X07, 0X87, 0X47, 0XC7, 0X27, 0XA7, 0X67, 0XE7, 0X17, 0X97, 0X57, 0XD7, 0X37, 0XB7, 0X77, 0XF7, 
    0X0F, 0X8F, 0X4F, 0XCF, 0X2F, 0XAF, 0X6F, 0XEF, 0X1F, 0X9F, 0X5F, 0XDF, 0X3F, 0XBF, 0X7F, 0XFF
};

const std::string ucharByteTable[] = {
    "00000000", "00000001", "00000010", "00000011", "00000100", "00000101", "00000110", "00000111", 
    "00001000", "00001001", "00001010", "00001011", "00001100", "00001101", "00001110", "00001111", 
    "00010000", "00010001", "00010010", "00010011", "00010100", "00010101", "00010110", "00010111", 
    "00011000", "00011001", "00011010", "00011011", "00011100", "00011101", "00011110", "00011111", 
    "00100000", "00100001", "00100010", "00100011", "00100100", "00100101", "00100110", "00100111", 
    "00101000", "00101001", "00101010", "00101011", "00101100", "00101101", "00101110", "00101111", 
    "00110000", "00110001", "00110010", "00110011", "00110100", "00110101", "00110110", "00110111", 
    "00111000", "00111001", "00111010", "00111011", "00111100", "00111101", "00111110", "00111111", 
    "01000000", "01000001", "01000010", "01000011", "01000100", "01000101", "01000110", "01000111", 
    "01001000", "01001001", "01001010", "01001011", "01001100", "01001101", "01001110", "01001111", 
    "01010000", "01010001", "01010010", "01010011", "01010100", "01010101", "01010110", "01010111", 
    "01011000", "01011001", "01011010", "01011011", "01011100", "01011101", "01011110", "01011111", 
    "01100000", "01100001", "01100010", "01100011", "01100100", "01100101", "01100110", "01100111", 
    "01101000", "01101001", "01101010", "01101011", "01101100", "01101101", "01101110", "01101111", 
    "01110000", "01110001", "01110010", "01110011", "01110100", "01110101", "01110110", "01110111", 
    "01111000", "01111001", "01111010", "01111011", "01111100", "01111101", "01111110", "01111111", 
    "10000000", "10000001", "10000010", "10000011", "10000100", "10000101", "10000110", "10000111", 
    "10001000", "10001001", "10001010", "10001011", "10001100", "10001101", "10001110", "10001111", 
    "10010000", "10010001", "10010010", "10010011", "10010100", "10010101", "10010110", "10010111", 
    "10011000", "10011001", "10011010", "10011011", "10011100", "10011101", "10011110", "10011111", 
    "10100000", "10100001", "10100010", "10100011", "10100100", "10100101", "10100110", "10100111", 
    "10101000", "10101001", "10101010", "10101011", "10101100", "10101101", "10101110", "10101111", 
    "10110000", "10110001", "10110010", "10110011", "10110100", "10110101", "10110110", "10110111", 
    "10111000", "10111001", "10111010", "10111011", "10111100", "10111101", "10111110", "10111111", 
    "11000000", "11000001", "11000010", "11000011", "11000100", "11000101", "11000110", "11000111", 
    "11001000", "11001001", "11001010", "11001011", "11001100", "11001101", "11001110", "11001111", 
    "11010000", "11010001", "11010010", "11010011", "11010100", "11010101", "11010110", "11010111", 
    "11011000", "11011001", "11011010", "11011011", "11011100", "11011101", "11011110", "11011111", 
    "11100000", "11100001", "11100010", "11100011", "11100100", "11100101", "11100110", "11100111", 
    "11101000", "11101001", "11101010", "11101011", "11101100", "11101101", "11101110", "11101111", 
    "11110000", "11110001", "11110010", "11110011", "11110100", "11110101", "11110110", "11110111", 
    "11111000", "11111001", "11111010", "11111011", "11111100", "11111101", "11111110", "11111111",
};

static inline const uchar rb(uchar _c)
{
    return revertByteTable[(short)_c];
}

static inline const std::string c2b(uchar _c)
{
    return ucharByteTable[(short)_c];
}

struct BitCharStruct 
{
    unsigned char c;
    BitCharStruct(unsigned char _c) : c(_c) {}
};

inline std::ostream& operator<<(std::ostream& o, const BitCharStruct& bs)
{
    std::bitset<8> b = bs.c;
    return (o << b[7] << b[6] << b[5] << b[4] << " " << b[3] << b[2] << b[1] << b[0]);
}

inline BitCharStruct bit(unsigned char _c)
{
    return BitCharStruct(_c);
}

inline BitCharStruct lbit(unsigned char _c)
{
    return BitCharStruct(rb(_c));
}