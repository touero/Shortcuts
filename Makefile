CC = rustc
TARGET = main
SOURCE = main.rs

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SOURCE)
	@echo "Compiling $(SOURCE) to create executable..."
	$(CC) $(SOURCE) -o $(TARGET)
	@echo "Compilation complete, created executable: $(TARGET)"

clean:
	@echo "Cleaning up generated files..."
	rm -f $(TARGET)
	@echo "Cleanup complete"

