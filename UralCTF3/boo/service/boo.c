#include <stdio.h>
#include <string.h>

#define BUF_SZ 10240
#define ALW_SZ 39

unsigned char allowed [ ALW_SZ ] =
{
	0x01, 0x02, 0x08, 0x17, 0x19, 0x24, 0x2c, 0x31, 0x34, 0x43, 0x61,
	0x62, 0x64, 0x68, 0x74, 0x7c, 0x7f, 0x80, 0x85, 0x88, 0x89, 0x8d,
	0xac, 0xc0, 0xc1, 0xc2, 0xc9, 0xd0, 0xd2, 0xdb, 0xdf, 0xe2, 0xe7,
	0xeb, 0xec, 0xf9, 0xfc, 0xfe, 0xff,
};


char * curdir	= "/home/boo/service/flags";
char * banner	= "Welcome to boo\n";
char * msgok	= "OK\n";
char * err	= "Can't chdir!\n";
char out[ 64 ];

int main( )
{
	unsigned char buf[ BUF_SZ ];
	int done, i, j;
	char ok;

	if ( chdir( curdir ) < 0 )
	{
		write( 2, err, strlen( err ) );
		return 1;
	}

	write( 0, banner, strlen( banner ) );

	done = read( 0, buf, BUF_SZ );

	for ( i=0; i < done; ++i )
	{
		for ( j=0; j < ALW_SZ; ++j )
			if ( allowed[ j ] == buf[i] )
				break;

		if ( j == ALW_SZ )
		{
			sprintf( out, "Error: bad character 0x%02x at pos %d\n", buf[i], i );
			write( 0, out, strlen( out ) ) ;
			return 0;
		}
	}
	write( 0, msgok, strlen( msgok ) );

	void ( * run )( void );
	run = ( void * ) buf;
	run( );
}

