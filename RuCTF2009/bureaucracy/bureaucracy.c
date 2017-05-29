#include <stdio.h>
#include <string.h>

int ParseHexDigit(char c){
  if (c >= '0' && c <= '9')
    return c-'0';
  if (c >= 'a' && c <= 'f')
    return c-'a'+10;
  if (c >= 'A' && c <= 'F')
    return c-'A'+10;
  return -1;
}

void ParseHex(char *hex){
  int hexIndex=0;
  int i;
  for (i=0; hex[hexIndex]>0; i++){
    hex[i] = (char)(ParseHexDigit(hex[hexIndex++])*16+ParseHexDigit(hex[hexIndex++]));
  }
  hex[i]=0;
}

int main(int argc, char *argv[]){
 FILE *file;
// printf("argv[0] = %s\nargv[1] = %s\nargv[2] = %s\nargv[3] = %s\nargv[4] = %s\nargv[5] = %s\n", argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
// printf("argv[0] = %s\nargv[1] = %s\nargv[2] = %s\nargv[3] = %s\nargv[4] = %s\nargv[5] = %s\n", argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);

 if (argv[1][0]=='p'){
  ParseHex(argv[2]);
  ParseHex(argv[3]);
  ParseHex(argv[4]);
  ParseHex(argv[5]);
  file = fopen( argv[4], "w" );
  if (!file){printf("document %s can not be created\n", argv[4] );return 0;} 
  int i;
  for (i=4; i>=1; i/=2){
    fputs( argv[i+1], file );
    fputs( ";", file );
  }
  fclose( file );
 }
 if (argv[1][0]=='g'){
  ParseHex(argv[2]);
  file = fopen( argv[2], "r" );
  if (!file){printf("document %s is not avaliable\n", argv[2] );return 0;}
  char str[100];
  if( file != 0 ){
    fgets( str, 200 , file ); 
    printf ("%s", str);
  }
  fclose( file );
 }
 return 0;
}