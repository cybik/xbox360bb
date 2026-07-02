X360BB_MODULE=xbox360bb
X360BB_VERSION=0.0.1
DKMS_FLAGS= -m $(X360BB_MODULE) -v $(X360BB_VERSION) --sourcetree "`pwd`/.." $(USER_DKMS_FLAGS)

obj-m += src/

CURRENT := $(shell uname -r)
PWD := $(shell pwd)
KDIR := /lib/modules/$(CURRENT)/build

all: modules

modules:
	$(MAKE) LLVM=1 -C $(KDIR) M=$(PWD) modules

install:
	$(MAKE) LLVM=1 -C $(KDIR) M=$(PWD) modules_install

clean:
	$(MAKE) LLVM=1 -C $(KDIR) M=$(PWD) clean

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
