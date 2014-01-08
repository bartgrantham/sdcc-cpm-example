#include "ansi_term.h"

#include "cpm_sysfunc.h"

#define ESC_CHR 0x1B
#define VT100_ANSI_CMD "<" // Sets VT100 and compatibles to ANSI mode 

#define ANSI_CLRSCRN	"[_J"	// Erase screen
#define ANSI_CLRLINE	"[_K"	// Erase line
#define ANSI_CURDIRADR	"[___;___H"	// Direct address of cursor position Y X
#define ANSI_CURMOVE	"[___X" // Move cursor up/down/left/right X spots

void term_sendCommand(char *cmd);

void term_ANSIMode(void) {
	term_sendCommand(VT100_ANSI_CMD);
}

void term_ANSIDirectCursorAddr(uint8_t column, uint8_t line) {
	char cmd[] = ANSI_CURDIRADR;

	// Generate the proper ascii numbers for the command
	cmd[5] = (column / 100) + 0x30;
	column -= (100 * (column / 100));
	cmd[6] = (column / 10) + 0x30;
	column -= (10 * (column / 10));
	cmd[7] = column + 0x30;
	
	cmd[1] = (line / 100) + 0x30;
	line -= (100 * (line / 100));
	cmd[2] = (line / 10) + 0x30;
	line -= (10 * (line / 10));
	cmd[3] = line + 0x30;

	term_sendCommand(cmd);
}

void term_ANSICursorMove(uint8_t spaces, ModeDir dir) {
	char cmd[] = ANSI_CURMOVE;

	switch (dir) {
		case move_up:
			cmd[4] = 'A';
			break;
		case move_down:
			cmd[4] = 'B';
			break;
		case move_right:
			cmd[4] = 'C';
			break;
		case move_left:
		default:
			cmd[4] = 'D';
			break;
	}

	// Convert the spaces value into ASCII
	cmd[1] = (spaces / 100) + 0x30;
	spaces -= (100 * (spaces / 100));
	cmd[2] = (spaces / 10) + 0x30;
	spaces -= (10 * (spaces / 10));
	cmd[3] = spaces + 0x30;
}

void term_ANSIClrLine(EraseDir dir) {
	char cmd[] = ANSI_CLRLINE;

	switch(dir) {
		case erase_after:
			cmd[1] = '0';
			break;
		case erase_before:
			cmd[1] = '1';
			break;
		case erase_all:
		default:
			cmd[1] = '2';
			break;		
	}

	term_sendCommand(cmd);
}

void term_ANSIClrScrn(EraseDir dir) {
	char cmd[] = ANSI_CLRSCRN;

	switch(dir) {
		case erase_after:
		case erase_before:
			cmd[1] = '0';
			break;
		case erase_all:
		default:
			cmd[1] = '2';
			break;
	}

	term_sendCommand(cmd);
}

void term_ANSISetParam(uint8_t prm) {
	char cmd[] = "[_;_;_;_;_m";
	int idx = 1;

	if (prm & 0x01) {
		cmd[idx] = 0;
	}

	if (prm & 0x02) {
		idx += 2;
		cmd[idx] = 1;
	}

	if (prm & 0x04) {
		idx += 2;
		cmd[idx] = 4;
	}

	if (prm & 0x08) {
		idx += 2;
		cmd[idx] = 5;
	}

	if (prm & 0x0F) {
		idx += 2;
		cmd[idx] = 7;
	}

	cmd[idx + 1] = 'm';
	cmd[idx + 2] = '\0';
	
	term_sendCommand(cmd);
}

void term_sendCommand(char *cmd) {
	int idx = 0;

	cpm_putchar(ESC_CHR);
	while (cmd[idx] != '\0') {
		cpm_putchar(cmd[idx]);
		idx++;
	}
}
