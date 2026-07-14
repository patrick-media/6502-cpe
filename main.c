#include<stdio.h>
#include<string.h>
#include<stdint.h>
#include<windows.h>

#include"cpe.h"

char *g_filein = NULL;
char *g_fileout = NULL;

char *g_board_fqbn = NULL;
char *g_cli_path = NULL;
char *g_port = NULL;

char *program_data = NULL;

uint8_t g_flags = 0;

// example: ./cpe.exe -bin test.bin -fqbn arduino:renesas_uno:minima -cli arduino-cli -p COM4
int main( int argc, char** argv ) {
	for( int i = 0; i < argc; i++ ) {
		if( strcmp( argv[ i ], "-bin" ) == 0 ) { // bin file input
			if( g_filein ) {
				err( "argument '-bin' supplied more than once." );
				exit( 1 );
			}
			g_filein = calloc( 128, sizeof( *g_filein ) );
			strcpy( g_filein, argv[ i+1 ] );
		}
		if( strcmp( argv[ i ], "-o" ) == 0 ) { // output file name - doesn't work
			if( g_fileout ) {
				err( "argument '-o' supplied more than once." );
				exit( 1 );
			}
			g_fileout = calloc( 128, sizeof( *g_fileout ) );
			strcpy( g_fileout, argv[ i+1 ] );
		}
		if( strcmp( argv[ i ], "-c" ) == 0 ) { // compile only + keep out.ino
			g_flags |= 1;
		}
		if( strcmp( argv[ i ], "-fqbn" ) == 0 ) {
			if( g_board_fqbn ) {
				err( "argument '-fqbn' supplied more than once." );
				exit( 1 );
			}
			g_board_fqbn = calloc( 128, sizeof( *g_board_fqbn ) );
			strcpy( g_board_fqbn, argv[ i+1 ] );
		}
		if( strcmp( argv[ i ], "-cli" ) == 0 ) {
			if( g_cli_path ) {
				err( "argument '-cli' supplied more than once." );
				exit( 1 );
			}
			g_cli_path = calloc( 128, sizeof( *g_cli_path ) );
			strcpy( g_cli_path, argv[ i+1 ] );
		}
		if( strcmp( argv[ i ], "-p" ) == 0 ) {
			if( g_port ) {
				err( "argument '-p' supplied more than once." );
				exit( 1 );
			}
			g_port = calloc( 128, sizeof( *g_port ) );
			strcpy( g_port, argv[ i+1 ] );
		}
	}

	if( !g_filein ) {
		err( "invalid file name." );
		exit( 1 );
	}

	FILE *file_in = fopen( g_filein, "rb" );
	if( !file_in ) {
		errf( "opening file '%s'.", g_filein );
		exit( 1 );
	}

	uint8_t *buf = calloc( 32768, sizeof( *buf ) );
	mem_safe( buf );
	int read_status = fread( buf, sizeof( *buf ), 32768, file_in );
	if( read_status < 32768 ) {
		errf( "improper file size: %d/8192 bytes read.", read_status );
		exit( 1 );
	}
	/*
	for( int i = 0; i < 8184; i += 8 ) { // 8192 - 8 = 8184 -- manually setting last 8 bytes for reset vector to fit in EEPROM
		printf( "%04x  %02x %02x %02x %02x  %02x %02x %02x %02x\n", i,
				buf[ i ], buf[ i+1 ], buf[ i+2 ], buf[ i+3 ], buf[ i+4 ], buf[ i+5 ], buf[ i+6 ], buf[ i+7 ] );
	}
	*/
	
	program_data = calloc( 8192*6, sizeof( *program_data ) ); // 8192 bytes * 6 characters per program byte
	mem_safe( program_data );

	for( int i = 0, k = 0; i < 8192*6, k < 8184; i += 6, k++ ) {
		char temp[ 7 ];
		sprintf( temp, "0x%02x, ", buf[ k ] );
		strcat( program_data, temp );
	}

	for( int i = 8184, k = 32760; i < 8192, k < 32768; i += 6, k++ ) {
		char temp[ 7 ];
		sprintf( temp, "0x%02x, ", buf[ k ] );
		strcat( program_data, temp );
	}

	program_data[ 8192*6 - 2 ] = 0;

	free( buf );

	fclose( file_in );

	system( "mkdir out" );
	FILE *file_out = fopen( "./out/out.ino", "w" );
	if( !file_out ) {
		err( "opening output file." );
		exit( 1 );
	}

	fputs( program1, file_out );
	fputs( program_data, file_out );
	fputs( program2, file_out );

	free( program_data );
	fclose( file_out );
	if( g_filein ) free( g_filein );
	if( g_fileout) free( g_fileout );

	if( !g_cli_path ) {
		err( "arduino-cli path not specified." );
		exit( 1 );
	}
	char cmd[ 128 ];
	sprintf( cmd, "\"%s\" compile --fqbn %s out/out.ino", g_cli_path, g_board_fqbn );
	system( cmd );

	if( !g_port ) {
		err( "port not specified." );
		exit( 1 );
	}
	sprintf( cmd, "\"%s\" upload -p %s --fqbn %s out/out.ino", g_cli_path, g_port, g_board_fqbn );
	system( cmd );

	printf( "CPE: Done\n" );

	return 0;
}
