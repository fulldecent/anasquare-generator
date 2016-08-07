/*
 * MAKES AND SOLVES ANASQUARE PUZZLES
 *
 * This program supports easy Anasquares, edit the defines below
 * OPTIMIZED FOR THE EASY VERSION OF ANASQUARE
 *
 * Usage: ./compose SIZE
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#define MAXSIZE 20
int SIZE;

/* BFS of solutions
 * board: letters currently placed on the board, letters will always satisfy all masks
 * mask (across & down): letters available to place by row or column
 */
int search(char board[MAXSIZE*MAXSIZE], int a_mask[MAXSIZE][26], int d_mask[MAXSIZE][26], int solutions_found /* =0 */)
{
	int i, j, k;
	char c;

	char my_board[MAXSIZE*MAXSIZE];
	int my_a_mask[MAXSIZE][26], my_d_mask[MAXSIZE][26];

	for (i=0; i<SIZE*SIZE && board[i]!='.'; i++);
	if (i==SIZE*SIZE) {
	        for (j=0; j<SIZE; j++) {
       			for (k=0; k<SIZE; k++)
      		                 printf("%c", board[j*SIZE+k]);
			printf(" "); 
        	}
		puts("");
		return solutions_found+1;
	}
	memcpy(my_board, board, sizeof(board[0]) * SIZE * SIZE);
	memcpy(my_a_mask, a_mask, sizeof(a_mask[0][0]) * SIZE * 26);	
	memcpy(my_d_mask, d_mask, sizeof(d_mask[0][0]) * SIZE * 26);	

	/* The next decision is cueued up */
	for (c='a'; c<='z'; c++) {
		if (my_a_mask[i/SIZE][c-'a'] == 0 || my_d_mask[i%SIZE][c-'a'] == 0)
			continue;
		my_board[i] = c;
		my_a_mask[i/SIZE][c-'a']--;
		my_d_mask[i%SIZE][c-'a']--;
		j = search(my_board, my_a_mask, my_d_mask, solutions_found);
		if (j)
			solutions_found = j;
		if (j==2)
			return 2;
		my_a_mask[i/SIZE][c-'a']++;
		my_d_mask[i%SIZE][c-'a']++;
	} 

	return solutions_found;
}


int main(int argc, char ** argv) 
{
	int i, j;
	char across[MAXSIZE][MAXSIZE+2]={{0}};
	char down[MAXSIZE][MAXSIZE+1]={{0}};
	char board[MAXSIZE*MAXSIZE]={0};
	char inword[255]; /* Top to bottom, left to right */

	if (argc != 2) {
		fprintf(stderr, "Usage: compose SIZE\n");
		return 1;
	}
	SIZE=atoi(argv[1]);

	int a_mask[MAXSIZE][26]={{0}};
	int d_mask[MAXSIZE][26]={{0}};

	fprintf(stderr, "Enter %d across words:\n",SIZE);
	for (i=0; i<SIZE; i++) {
		scanf("%255s", inword);
		for (j=0; j<SIZE; j++) {
			across[i][j] = tolower(inword[j]);
			a_mask[i][tolower(inword[j])-'a']++;
		}
	}
	fprintf(stderr, "Enter %d down words:\n",SIZE);
	for (i=0; i<SIZE; i++) {
		scanf("%255s", inword);
		for (j=0; j<SIZE; j++) {
			down[i][j] = tolower(inword[j]);
			d_mask[i][tolower(inword[j])-'a']++;
		}
	}
	fprintf(stderr, "Enter board: top to bottom & left to right, use period (.) for unknowns\n");
	for (i=0; i<SIZE*SIZE; i++) {
		do {
			scanf("%c", &(board[i]));
		} while (!isalpha(board[i]) && !ispunct(board[i]));
		if (isalpha(board[i])) {
			board[i] = toupper(board[i]);
			a_mask[i/SIZE][board[i]-'A']--;
			d_mask[i%SIZE][board[i]-'A']--;
		}
	}
	fprintf(stderr, "\n");

	fprintf(stderr, "ACROSS\n");
	for (i=0; i<SIZE; i++)
        puts(across[i]);
	fprintf(stderr, "\nDOWN\n");
	for (i=0; i<SIZE; i++)
        puts(down[i]);
    puts("");
	fprintf(stderr, "BOARD\n");
	for (i=0; i<SIZE; i++) {
		for (j=0; j<SIZE; j++)
			printf("%c  ", board[i*SIZE+j]);
		puts("");
	}
    puts("");

	for (i=0; i<SIZE; i++) 
		for (j=0; j<26; j++) 
			if (a_mask[i][j] < 0) 
				return 99;
	for (i=0; i<SIZE; i++) 
		for (j=0; j<26; j++) 
			if (d_mask[i][j] < 0) 
				return 98;

	i = search(board, a_mask, d_mask, 0);
	if (i == 0)
		puts("\n== NO SOLUTIONS FOUND");
	else if (i == 1)
		puts("\n== UNIQUE SOLUTION FOUND");
	else
		puts("\n== MULTIPLE SOLUTIONS FOUND");

	return i-1;
}
