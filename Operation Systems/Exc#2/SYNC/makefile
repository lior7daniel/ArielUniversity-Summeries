all: 1_1 1_2 2_1 2_2 3_1 3_2

1_1: 
	gcc -pthread -o 1_1 2_1_1.c
1_2: 
	gcc -pthread -o 1_2 2_1_2.c
2_1: 
	gcc -pthread -o 2_1 2_2_1.c
2_2:
	gcc -pthread -o 2_2 2_2_2.c
3_1: 
	gcc -pthread -o 3_1 2_3_1.c
3_2: 
	gcc -pthread -o 3_2 2_3_2.c

clean:
	rm -f *.o 2_1_1 2_1_2 2_2_1 2_2_2 2_3_1 2_3_2
