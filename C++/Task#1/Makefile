CCX = g++ -std=c++0x

a.out: Document.o Editor.o
		$(CCX) main.cpp *.o

Document.o: Document.cpp Document.h
		$(CCX) -c Document.cpp

Editor.o: Editor.cpp Editor.h
		$(CCX) -c Editor.cpp

clean:
		-rm *.o a.out