#include <iostream>
#include <iomanip>

struct HexCharStruct
{
    unsigned char c;
    HexCharStruct(unsigned char _c) : c(_c) {}
};

inline std::ostream& operator<<(std::ostream& o, const HexCharStruct& hs)
{
    return (o << std::setfill('0') 
              << std::hex 
              << std::setw(2) 
              << (int)hs.c);
}

inline HexCharStruct hex(unsigned char _c)
{
    return HexCharStruct(_c);
}

inline u_int16_t HexLE16(char* _s)
{
    return ((u_int8_t)_s[0]) | 
           ((u_int8_t)_s[1]) << 8;
}

inline u_int32_t HexLE32(char* _s)
{
    return ((u_int8_t)_s[0]) | 
           ((u_int8_t)_s[1]) << 8  |
           ((u_int8_t)_s[2]) << 16 |
           ((u_int8_t)_s[3]) << 32 ;
}