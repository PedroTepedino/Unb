#include <fstream>
#include <iterator>
#include <vector>
#include <iostream>
#include <bitset>
#include <string>
#include <iomanip>
// #include <algorithm>

#include "hex.h"
#include "col.h"

using namespace std;

using std::cout;

struct Date {
    int year;
    int month;
    int day;
};

// std::string toUpper( std::string s)
// {
//     std::transform(s.begin(), s.end(), s.begin(), ::toupper);
//     return s;
// }

// std::string toLower( std::string s)
// {
//     std::transform(s.begin(), s.end(), s.begin(), ::toLower);
//     return s;
// }


std::vector<col> readDBFInput( ifstream* stream)
{    
    // aux buffer
    char *buffer;
    char buff; // single character buffer

    // Ignore first byte
    stream->ignore();

    // Read last date Updated at bytes 1-3
    Date date;
    buffer = new char[3];

    stream->read(buffer, 3);

    date = (Date) 
    {
        .year = 1900 + (int)buffer[0], 
        .month = buffer[1], 
        .day = buffer[2] 
    };
    
    cout << "last modified: " 
         << date.day 
         << " / " 
         << date.month 
         << " / " 
         << date.year
         << endl;

    delete[] buffer;

    // Get Number of records in the datbase
    u_int32_t recordsNum = 0x00000000;
    buffer = new char[4];

    stream->read(buffer, 4);
    recordsNum = HexLE32(buffer);
    cout << "Number of Records: " << recordsNum << endl;


    // Get header size at bytes 8-9
    u_int16_t headerSize = 0x0000;
    buffer = new char[2];

    stream->read(buffer, 2);
    headerSize = HexLE16(buffer);
    // headerSize = ((u_int8_t)buffer[0]) | (((u_int8_t)buffer[1]) << 8);

    cout << "Header size: " << headerSize << endl;
    delete[] buffer;

    // Get number of bytes in the record   
    u_int16_t recordSize = 0x0000;
    buffer = new char[2];

    stream->read(buffer, 2);
    recordSize = HexLE16(buffer);

    cout << "Record size: " << recordSize << " bytes" << endl;
    delete[] buffer;
    
    // ignore bytes 12-13 : Reserved
    stream->ignore(2);

    // Check incomplete transaction flag
    stream->get(buff);
    if(buff == 0x00)
        cout << "Transaction completed" << endl;
    else
        cout << "Imcomplete Transaction Identified!" << endl;

    // Check Encryption
    stream->get(buff);
    if(buff == 0x00)
        cout << "No Encryption found" << endl;
    else
        cout << "File Encrypted" << endl;

    // ignore bytes 16-27 - Multi user environment
    stream->ignore(12);

    // .mdx file flag
    stream->get(buff);
    if(buff == 0x00)
        cout << "No production .mdx file" << endl;
    else
        cout << ".mdx file flag found" << endl;

    // language driver
    stream->get(buff);
    cout << "Language Driver ID: " << hex(buff) << endl;
    cout << std::dec; 

    // ignore bytes 30-31 - Reserved
    stream->ignore(2);

    // Array of field descriptors
    cout << endl << "Descriptors found: " << headerSize / 32 << endl;
    u_int8_t fieldDecimalCount;
    u_int16_t workAreaID;
    char workAreaIDBuffer[2];
    buffer = new char[11];

    std::vector<col> cols;
    
    for (int i = 0; i < (headerSize / 32) - 1; i++)
    {
        // Field descriptor
        stream->read(buffer, 11);
        cols.push_back((col) {.descriptor=(string)buffer});

        // Field Type
        stream->get(buff);
        cols[i].fieldType = buff;

        // Ignore Reserved 4 bytes
        stream->ignore(4);

        // Field Length
        stream->get(buff);
        cols[i].fieldSize = (int)buff;

        // Field Decimal Count in Binary
        stream->get(buff);
        cols[i].filedDecimal = (int) buff;

        // Work Area ID
        stream->read(workAreaIDBuffer, 2);
        workAreaID = HexLE16(workAreaIDBuffer);

        // Ignore Example
        // Ignore bytes 21-30 - Reserved
        // Ignore MDX flag
        // 12 bytes total
        stream->ignore(12);
        
        // cout << "Descriptor: "
        //      << setfill(' ')
        //      << setw(11)
        //      << descriptor
        //      << " | type : "
        //      << fieldType 
        //      << " | field length : "
        //      << setw(3) 
        //      << fieldLength
        //      << " | field count decimal : "
        //      << fieldDecimalCount
        //      << " | work area ID: "
        //      << workAreaID
        //      << endl;
    }
    delete[] buffer;

    for (auto s: cols)
        cout << s.descriptor << " : " << s.fieldSize << endl;
    cout << endl;

    int recordSizesSum = 0;
    for (auto c: cols)
        recordSizesSum += c.fieldSize;
    cout << "Record sizes sum: " << recordSizesSum << endl;

    // End Of header
    stream->get(buff);
    cout << "End of Header: " << hex(buff) << endl;

    // Reading Records
    for (int i = 0; i < recordsNum; i++)
    {
        stream->get(buff);
        if (buff == 0x2A) // this entrie should be ignored
        {
            cout << "Ignore data stream!" << endl;
            stream->ignore(recordSize - 1);
            continue;
        }
        else if (buff != 0X20)
            cout << "Erro de leitura!! entrada: " << i << endl;

        buffer = new char[recordSize - 1];
        stream->read(buffer, recordSize - 1); 
        // cout << "buffer: " << buffer << endl;
        int offset = 0;
        for (int j = 0; j < cols.size(); j++)
        {
            string aux = "";
            for (int k = 0; k < cols[j].fieldSize; k++)
            {
                aux.push_back(buffer[offset + k]);
            }
            offset += cols[j].fieldSize;
            cols[j].data.push_back(aux);
        }
        delete[] buffer;
    }

    // for (int i = 0; i < 3 /* recordsNum; i++)
    // {
    //     for (int j = 0; j < cols.size(); j++)
    //     {
    //         cout << cols[j].descriptor << " : " <<  cols[j].data[i] << endl;
    //     }
    //     cout << endl;
    // }
   
    return cols; // file read successfully
}

void WriteCSV(std::vector<col> data, ofstream* stream)
{
    string aux = "";
    for (int i = 0; i < data.size(); i++)
        aux += "\"" + data[i].descriptor + "\";" ;      
    aux.pop_back();
    aux.push_back('\n');

    // cout << aux ;

    (*stream) << aux;

    for (int i = 0; i < data[0].data.size(); i++)
    {
        aux = "";
        for(int j = 0; j < data.size(); j++)
        {
            aux += "\"" + data[j].data[i] + "\";";
            
        }
        aux.pop_back();
        aux.push_back('\n');
        // cout << aux;
        (*stream) << aux;
    }
}

string ToCSV(std::vector<col> data)
{
    string aux = "";
    for (int i = 0; i < data.size(); i++)
        aux += "\"" + data[i].descriptor + "\";" ;      
    aux.pop_back();
    aux.push_back('\n');

    for (int i = 0; i < data[0].data.size(); i++)
    {
        for(int j = 0; j < data.size(); j++)
        {
            aux += "\"" + data[j].data[i] + "\";";
            
        }
        aux.pop_back();
        aux.push_back('\n');
    }
    return aux;
}

std::string TranslateType(char _t, int size)
{
    switch (_t)
    {
        case 'C':
            if (size > 1)
                return "VARCHAR(" + to_string(size) + ")";
            else
                return "CHAR(1)";
        case 'D': // TODO: Complete other types
            return "null";
    }
    return "null";
}

string ToMysql(std::vector<col> data, string tableName)
{
    string stream = "";

    stream += "CREATE TABLE " + tableName /*toUpper(tableName)*/ + "(\n";
    
    for (int i = 0; i < data.size(); i++)
        stream += "\t " + data[i].descriptor /*toLower(data[i].descriptor)*/ + ' ' + TranslateType(data[i].fieldType, data[i].fieldSize) +",\n";

    stream += ");\n";
    return stream;
}

int main(int argc, char** argv)
{
    // cout << argv[1] << " " << argv[2] <<endl;
    std::ifstream input(argv[1], std::ios::binary);
    std::vector<col> db = readDBFInput(&input);
    input.close();

    cout << "<--->" << endl;

    std::ofstream output(argv[2]);
    // WriteCSV(db, &output);
    output << ToCSV(db);
    // cout << ToMysql(db, argv[3]);
    // output << ToMysql(db, argv[3]);
    output.close();


    return 0;
} 