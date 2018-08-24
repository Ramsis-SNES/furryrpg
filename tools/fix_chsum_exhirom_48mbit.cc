/* fread example: read an entire file */
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>

using namespace std;

int main (int argc, char * argv[]) {
  string inFile = "";
  if (argc == 2) {
    inFile = argv[1];
  }
  else {
    cout << "Usage: ./fix_chsum_exhirom_48mbit <ROM file name>\n";
    return 1;
  }

  FILE * ROMfile;
  long lSize;
  char * buffer;
  size_t result;

  unsigned long int chsum = 0, chsum_compl = 0xFFFF;
  unsigned char clo, chi, cclo, cchi;

  ROMfile = fopen(argv[1], "rb");
  if (ROMfile==NULL) {fputs ("Error: File does not exist\n",stderr); exit (1);}

  // obtain file size:
  fseek(ROMfile, 0, SEEK_END);
  lSize = ftell(ROMfile);
  rewind(ROMfile);

  if (lSize != 0x600000) {fputs ("Error: File is not 48 Mbit\n",stderr); exit (1);}

  // allocate memory to contain the whole file:
  buffer = (char*) malloc (sizeof(char)*lSize);
  if (buffer == NULL) {fputs ("Error: Memory error\n",stderr); exit (2);}

  // copy the file into the buffer:
  result = fread (buffer,1,lSize,ROMfile);
  if (result != lSize) {fputs ("Error: Read error\n",stderr); exit (3);}

  // add 6 * 0xFF (bank $40 is read twice)
  chsum += 0x5FA;

  // read banks $00 - $5F
  for(unsigned Offset=0; Offset < lSize; ++Offset) {
    // skip checksum bytes
    if((Offset >= 0xFFDC && Offset < 0xFFE0) || (Offset >= 0x40FFDC && Offset < 0x40FFE0)) continue;

    chsum += buffer[Offset] & 0xFF;
  }

  // read banks $40 - $5F again
  for(unsigned Offset=0x400000; Offset < lSize; ++Offset) {
    // skip checksum bytes
    if(Offset >= 0x40FFDC && Offset < 0x40FFE0) continue;

    chsum += buffer[Offset] & 0xFF;
  }

  fclose(ROMfile);
  free(buffer);

  chsum &= 0xFFFF;
  chsum_compl ^= chsum;

  printf("Checksum: %x\n",chsum);
  printf("Checksum complement: %x\n",chsum_compl);

  // transfer checksum values to char variables for upcoming fput() functions
  cclo = chsum_compl & 0xFF;
  cchi = chsum_compl >> 8;
  clo = chsum & 0xFF;
  chi = chsum >> 8;

  // write checksum into ROM file
  ROMfile = fopen(argv[1], "rb+");

  fseek(ROMfile, 0xFFDC, SEEK_SET);
  fputc(cclo, ROMfile);
  fputc(cchi, ROMfile);
  fputc(clo, ROMfile);
  fputc(chi, ROMfile);

  fseek(ROMfile, 0x40FFDC, SEEK_SET);
  fputc(cclo, ROMfile);
  fputc(cchi, ROMfile);
  fputc(clo, ROMfile);
  fputc(chi, ROMfile);

  fclose(ROMfile);

  return 0;
}
