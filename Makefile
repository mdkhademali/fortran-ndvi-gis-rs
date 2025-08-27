FC = gfortran
FFLAGS = -O2 -fimplicit-none
SRC = src/main.f90 src/ascii_grid.f90
OBJ = $(SRC:.f90=.o)
TARGET = bin/ndvi

all: $(TARGET)

$(TARGET): $(SRC)
	@mkdir -p bin
	$(FC) $(FFLAGS) -o $(TARGET) $(SRC)

run: $(TARGET)
	@mkdir -p output
	./$(TARGET)

clean:
	rm -f bin/* *.mod

.PHONY: all run clean
