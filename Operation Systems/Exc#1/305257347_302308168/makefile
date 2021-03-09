playAll: myApp1_1 myApp1_2 myApp1_3 myApp2_1 myApp2_2 myApp2_3 myApp2_4

myApp1_1: main1_1.o hello_Ariel1_1.o
	gcc -o myApp1_1 main1_1.o hello_Ariel1_1.o

main1_1.o: main1_1.c
	gcc -c main1_1.c
	
hello_Ariel1_1.o: 
	gcc -c hello_Ariel1_1.c 
	
myApp1_2: main1_2.o libhello.so
	gcc -o myApp1_2 main1_2.o ./libhello.so

main1_2.o: main1_2.c
	gcc -c main1_2.c

libhello.so: hello_ariel1_2.o
	gcc -shared -o libhello.so hello_ariel1_2.o
	
hello_ariel1_2.o: 
	gcc -c -fPIC hello_ariel1_2.c

myApp1_3: myApp1_2
	gcc -o myApp1_3 main1_3.c -ldl
	
myApp2_1:
	gcc -o myApp2_1 main2_1.c 

myApp2_2:
	gcc -o myApp2_2 main2_2.c 
	
myApp2_3:
	gcc -o myApp2_3 main2_3.c 

myApp2_4:
	gcc -o myApp2_4 main2_4.c 

clean:
	rm *.o myApp* lib*
	
	
	
	
	
	
	
	
	
	
	