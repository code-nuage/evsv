build: clean all install

clean:
	rm -rf build

all:
	cyan build --prune

install:
	luarocks build --local
