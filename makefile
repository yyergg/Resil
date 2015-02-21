Resil: Resil.cpp Resil.h
	g++ -m32 Resil.cpp redlib.a -o Resil

clean:
	find . -name '*.o' -type f -exec rm -f {} \;
	rm Resil
	rm ./models/*.ir
	rm ./models/*.redtab
