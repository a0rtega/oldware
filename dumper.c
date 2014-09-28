
/*
	something -> C unsigned char array
*/

#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[]) {

	int i;
	unsigned char c;
	FILE *dumped;

	if (argc != 2) {
		printf("Dumper\n");
		printf("./dumper file\n");
		return 1;
	}
	
	if ((dumped = fopen(argv[1], "rb")) == NULL) {
		printf("Error opening file.\n");
		return 1;
	}
	
	printf("\tunsigned char buff[] =");
	while (!feof(dumped)) {
		printf("\n\t\"");
		for (i = 0; i < 20; i++) {
			c = fgetc(dumped);
			if (feof(dumped)) {
				i = 20;
			}
			else {
				printf("\\x");
				if (c < 16) {
					printf("0");
				}
				printf("%x", c);
			}
		}
		printf("\"");

	}
	printf(";\n");
	
	fclose(dumped);
	
return 0;
}

