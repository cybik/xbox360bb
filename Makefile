obj-m := \
	./src/xbox360bb.o

CURRENT := $(shell uname -r)
PWD := $(shell pwd)
KDIR := /lib/modules/$(CURRENT)/build

all: default

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

install:
	make -C $(KDIR) M=$(PWD) modules_install

clean:
	make -C $(KDIR) M=$(PWD) clean

# Package version and name from dkms.conf
# Copied over from other works
VER := $(shell sed -n 's/^PACKAGE_VERSION=\([^\n]*\)/\1/p' dkms.conf 2>&1 /dev/null)
MODULE_NAME := $(shell sed -n 's/^PACKAGE_NAME=\([^\n]*\)/\1/p' dkms.conf 2>&1 /dev/null)

dkmsinstall:
	cp -R . /usr/src/$(MODULE_NAME)-$(VER)
	dkms install -m $(MODULE_NAME) -v $(VER)

dkmsremove:
	dkms remove -m $(MODULE_NAME) -v $(VER) --all
	rm -rf /usr/src/$(MODULE_NAME)-$(VER)
