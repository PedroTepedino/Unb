#include <fstream>
#include <iostream>
#include <bitset>
#include <string>
#include <vector>
#include <iomanip>

#include "decode.h"

using namespace std;
using std::cout;

typedef unsigned char uchar;

int header(ifstream* stream)
{
    int lineCount = 0;
    u_int16_t headerSize = 0x0000;
    vector<char> message;

    vector<char> dictionary;

    stream->seekg(8, ios::beg);

    char rawHeaderSize[2];
    stream->read(rawHeaderSize, 2);

    cout << hex(rawHeaderSize[0]) << " - " <<  hex(rawHeaderSize[1]) << endl;
    
    headerSize = (u_int8_t)rawHeaderSize[0] | (((u_int8_t)rawHeaderSize[1]) << 8);
    
    cout << std::dec << "header size = " << headerSize << endl;

    stream->seekg(0, ios::beg);

    char *buffer = new char[headerSize];

    stream->read(buffer, headerSize);

    for (int i = 0; i < headerSize; i++)
    {
        cout << buffer[i];
        if ((i + 1) % 16 == 0)
            cout << endl;
    }
    cout << endl << endl;

    for (int i = 0; i < headerSize; i++)
    {
        cout << hex(buffer[i]) << " ";
        if ((i + 1) % 16 == 0)
            cout << endl;
        else if ((i + 1) % 8 == 0)
            cout << " ";
    }
    cout << endl << endl << std::dec;

    delete buffer;

    buffer = new char[4];

    stream->read(buffer, 4);

    for (int i = 0; i < 4; i++)
    {
        cout << hex(buffer[i]) << " ";
        if ((i + 1) % 16 == 0)
            cout << endl;
        else if ((i + 1) % 8 == 0)
            cout << " ";
    }
    cout << endl << endl << std::dec;

    delete buffer;

    // ---------------------------

    stream->read(rawHeaderSize, 2);
    cout << hex(rawHeaderSize[0]) << " " << hex(rawHeaderSize[1]);
    cout << endl << endl;

    int bufferSize = 32;

    buffer = new char[bufferSize];

    stream->read(buffer, bufferSize);
    
    for (int i = 0; i < bufferSize; i++)
    {
        cout << hex(buffer[i]) << " ";
        if ((i + 1) % 16 == 0)
            cout << endl;
        else if ((i + 1) % 8 == 0)
            cout << " ";
    }
    cout << endl << endl << std::dec;

    for (int i = 0; i < bufferSize; i++)
    {
        cout << bit(buffer[i]) << "  ";
        if ((i + 1) % 8 == 0)
            cout << endl;
        else if ((i + 1) % 4 == 0)
            cout << "  ";
    }
    cout << endl << std::dec;

    for (int i = 0; i < bufferSize; i++)
    {
        cout << lbit(buffer[i]) << "  ";
        if ((i + 1) % 8 == 0)
            cout << endl;
        else if ((i + 1) % 4 == 0)
            cout << "  ";
    }
    cout << endl<< std::dec;


    int remainingBits = 8;
    vector<uchar> codes;
    std::string checksum = "";

    int index = 0;
    unsigned char c = buffer[index]; // get character in current index
    index++; // 1 // increase index

    // test first bit
    bool asciiLiteral = true;
    if (c & 0x01 == 0x01)
    {
        asciiLiteral = false;
    }

    if(asciiLiteral)
    {
        codes.push_back('0');
        cout << lineCount << " : 0 "; 
        checksum.push_back('0');
    }
    else
    {
        codes.push_back('1');
        cout << lineCount << " : 1 ";
        checksum.push_back('1');
    }
    lineCount ++;
    

    c = c >> 1; // discard tested bit (firts bit)
    remainingBits--; 
    c |= ((uchar)buffer[index]) << remainingBits; // get first bit from next byte
    cout << lbit(c);
    cout  << " - " << hex(c);
    cout << std::dec << " - " << remainingBits << endl;
    // cout << lbit(c) << "  ";
    message.push_back(c);
    dictionary.push_back(c);
    checksum.append(b(rb(c)));
    
    for (int i = 0; i < 25; i++)
    {
        c = c >> 8; // discard byte

        cout << endl << "remaining bits : " << remainingBits << endl;

        c = ((uchar)buffer[index]) >> (8 - remainingBits);
        index++;
        c |= ((uchar)buffer[index]) << remainingBits;

        asciiLiteral = true;
        if (c & 0x01 == 0x01)
        {
            asciiLiteral = false;
        }

        if(asciiLiteral)
        {
            codes.push_back('0');
            cout << lineCount << " : 0 "; 
            checksum.push_back('0');
        }
        else
        {
            codes.push_back('1');
            cout << lineCount << " : 1 ";
            checksum.push_back('1');
        }
        lineCount ++;

        if (asciiLiteral)
        {
            c = c >> 1;
            remainingBits--;
            if (remainingBits < 0)
            {
                remainingBits = 7;
                index++;
            }
            else
            {
                c |= ((uchar)buffer[index]) << remainingBits;
            }

            cout << lbit(c);
            cout  << " - " << hex(c);
            cout << std::dec << " - " << remainingBits << endl;
            // cout << lbit(c) << "  ";
            message.push_back(c);
            dictionary.insert(dictionary.begin(), c);

            checksum.append(b(rb(c)));
        }
        else
        {
            cout << endl << "Index : " << index  << " - " << bit(buffer[index]) << endl;
            remainingBits--;
            // cout << endl << "Sequence  Detected !!" << endl;
            // cout << "Decoding: " << endl;
            int preIndex = index;
            lengthOffsetPair pair = Decode(buffer, index, remainingBits);
            remainingBits -= pair.bits;
            remainingBits += (index - preIndex) * 8;
            if (remainingBits < 0)
                remainingBits += 8;
            // cout << "length: " <<  pair.length << endl;
            // cout << "offset: " <<  pair.offset << endl;
            cout << pair.dLength 
                 << " " 
                 <<  pair.dOfset 
                 << " " 
                 << pair.dOoffsseett 
                 << " - (" 
                 << pair.length 
                 << " : " 
                 << pair.offset 
                 << ") - "
                 << pair.bits
                 << " -> "
                 << remainingBits 
                 << endl;
            checksum.append(pair.dLength + pair.dOfset + pair.dOoffsseett );

            // cout << endl;
            // cout << endl << "index: " << index << endl;

            // for (auto d: dictionary)
            //     cout << hex(d) << " ";
            // cout << endl;
            
            for (int i = 0; i < pair.length; i++)
            {
                message.push_back(dictionary[pair.offset - i]);
            }

        }
    }

        // c = c >> 8; // discard byte

        // c = ((uchar)buffer[index]) >> (8 - remainingBits);
        // index++;
        // c |= ((uchar)buffer[index]) << remainingBits;

        // asciiLiteral = true;
        // if (c & 0x01 == 0x01)
        // {
        //     asciiLiteral = false;
        // }

        // if(asciiLiteral)
        // {
        //     codes.push_back('0');
        //     cout << "0 "; 
        // }
        // else
        // {
        //     codes.push_back('1');
        //     cout << "1 ";
        // }

        // c = c >> 1;
        // remainingBits--;
        // if (remainingBits <= 0)
        // {
        //     remainingBits = 8;
        //     index++;
        // }
        // else
        // {
        //     c |= ((uchar)buffer[index]) << remainingBits;
        // }
        // cout << lbit(c);
        // cout  << " - " << hex(c);
        // cout << std::dec << " - " << remainingBits << endl;
        // cout << lbit(c) << "  ";
        // message.push_back(c);


    cout << endl;

    std::string aux = "";    
    
    vector<u_int8_t> check, sum;
    for (int i = 0; i < checksum.size(); i++)
    {
        aux += checksum[i]; 

        if ((i + 1) % 8 == 0)
        {
            check.push_back(bh(aux));
            aux = "";
        }
    }

    for (int i = 0; i < check.size(); i++)
        sum.push_back(rb(buffer[i]));

    cout << "CHECKSUM :" << endl;

    for (int i = 0; i < check.size(); i++)
        cout << i
             << " : "
             << b(check[i], " ") 
             << " - " 
             << b(sum[i], " ") 
             << " | diff : " 
             << b(check[i] ^ sum[i], " ")
             << endl;

    cout << endl << endl;

    for (int i = 0; i < checksum.size(); i++)
    {
        cout << checksum[i];

        if ((i + 1) % 64 == 0)
            cout << endl;
        else if ((i + 1) % 32 == 0)
            cout << "    ";
        else if ((i + 1) % 8 == 0)
            cout << "  ";
        else if ((i + 1) % 4 == 0)
            cout << " ";   
    }

    cout << endl << endl;

    // string rebuiltStream = "";
    // for (int i = 0; i < message.size(); i++)
    // {
    //     rebuiltStream.push_back(codes[i] == 0x01 ? '1' : '0');
    //     rebuiltStream.append(b(rb(message[i])));
    // }

    // cout << endl << endl;

    // for (int i = 0; i < rebuiltStream.size(); i++)
    // {
    //     cout << rebuiltStream[i];

    //     if ((i + 1) % 64 == 0)
    //         cout << endl;
    //     else if ((i + 1) % 32 == 0)
    //         cout << "    ";
    //     else if ((i + 1) % 8 == 0)
    //         cout << "  ";
    //     else if ((i + 1) % 4 == 0)
    //         cout << " ";   
    // }

    cout << endl << endl;
    // cout << "<----------->";
    // cout << rebuiltStream; 
    // cout << endl << endl;

    // for (int i = 0; i < message.size(); i++)
    // {
    //     cout << codes[i] << " " << bit(message[i]) << " ";
    //     if ((i + 1) % 8 == 0)
    //         cout << endl;
    //     else if ((i + 1) % 4 == 0)
    //         cout << "  ";
    // }
    // cout <<endl;

    // for (int i = 0; i < message.size(); i++)
    // {
    //     cout << codes[i] << " " << lbit(message[i]) << " ";
    //     if ((i + 1) % 8 == 0)
    //         cout << endl;
    //     else if ((i + 1) % 4 == 0)
    //         cout << "  ";
    // }

    // cout << endl << endl;
    // cout << "symbles: " << message.size() << " - codes: " << codes.size();
    // cout << endl << endl;

    
    // for (int i = 0; i < bufferSize; i++)
    // {
    //     if (i < index)
    //         cout << "---- ----  ";
    //     else
    //         cout << lbit(buffer[i]) << "  ";
    //     if ((i + 1) % 8 == 0)
    //         cout << endl;
    //     else if ((i + 1) % 4 == 0)
    //         cout << "  ";
    // }
    // cout << endl << std::dec;

    // for (int i = 0; i < bufferSize; i++)
    // {
    //     if (i < index)
    //         cout << "-- ";
    //     else
    //         cout << hex(buffer[i]) << " ";
    //     if ((i + 1) % 16 == 0)
    //         cout << endl;
    //     else if ((i + 1) % 8 == 0)
    //         cout << " ";
    // }
    // cout << endl << endl << std::dec;

    for(auto i : message)
        cout << hex(i) << " ";


    delete buffer;





    // map<char, bitset> litteralsOne = {
    //     {0x20, }
    // };
    // vector<char> s;
    // char b;
    // while (!stream->eof())
    // {
    //     stream->get(b);
    //     s.push_back(b);
    //     // cout << b;
    //     if(b == 0x0D)
    //         break;
    // }

    // for (auto i : s)
    // {
    //     cout << i;
    // }
    // cout << endl << endl << endl ;
    
    // while (true)
    // {
    //     stream->get(b);
    //     if (stream->eof())
    //         break;

    //     s.push_back(b);
    // }

    // s = "";
    // int count = 0;
    // for (int i = 0; i < 128; i++)
    // {

    //     count++;
    //     cout << hex(b) << " ";
    // }
    // cout << endl << endl;
    // for (int i = 0; i < s.size(); i++)
    // {
    //     cout << bit(s[i]) << "  ";
    //     if ((i + 1) % 8 == 0)
    //     {
    //         cout <<  endl;
    //     }
    // }
    // for (int i = 0; i < s.size(); i++)
    // {
    //     cout << lbit(s[i]) << "  ";
    //     if ((i + 1) % 8 == 0)
    //     {
    //         cout <<  endl;
    //     }
    // }

    




    // for (auto i : s)
    // {
    //     cout << bit(i) << " ";
    // }

    // cout << endl << endl << endl ;
    
    // for (auto i : s)
    // {
    //     cout << lbit(i);
    // }
    return 0;
}

int main()
{
    std::ifstream input("./dnba2021-aux.dbc", std::ios::binary);
    
    header(&input);

    input.close();


    return 0;
}

