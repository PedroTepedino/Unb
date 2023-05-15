#include <fstream>
#include <iostream>
#include <bitset>
#include <string>
#include <vector>
#include <iomanip>

#include "hex.h"
#include "bit.h"

using namespace std;

typedef unsigned char uchar;

int header(ifstream* stream)
{
    u_int16_t headerSize = 0x0000;
    vector<char> message;

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
        cout << "0 "; 
    }
    else
    {
        codes.push_back('1');
        cout << "1 ";
    }
    

    c = c >> 1; // discard tested bit (firts bit)
    remainingBits--; 
    c |= ((uchar)buffer[index]) << remainingBits; // get first bit from next byte
    cout << lbit(c);
    cout  << " - " << hex(c);
    cout << std::dec << " - " << remainingBits << endl;
    // cout << lbit(c) << "  ";
    message.push_back(c);
    
    for (int i = 0; i < 16; i++)
    {
        c = c >> 8; // discard byte

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
            cout << "0 "; 
        }
        else
        {
            codes.push_back('1');
            cout << "1 ";
        }

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

    string rebuiltStream = "";
    for (int i = 0; i < message.size(); i++)
    {
        rebuiltStream.push_back(codes[i] == 0x01 ? '1' : '0');
        rebuiltStream.append(c2b(rb(message[i])));
    }

    cout << endl << endl;

    for (int i = 0; i < rebuiltStream.size(); i++)
    {
        cout << rebuiltStream[i];

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

    
    for (int i = 0; i < bufferSize; i++)
    {
        if (i < index)
            cout << "---- ----  ";
        else
            cout << lbit(buffer[i]) << "  ";
        if ((i + 1) % 8 == 0)
            cout << endl;
        else if ((i + 1) % 4 == 0)
            cout << "  ";
    }
    cout << endl << std::dec;

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

