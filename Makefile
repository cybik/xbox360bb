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
	rm -rf $(PWD)/cmake-build*

# Package version and name from dkms.conf
# Copied over from other works
VER := $(shell sed -n 's/^PACKAGE_VERSION=\([^\n]*\)/\1/p' dkms.conf 2>&1 /dev/null)
MODULE_NAME := $(shell sed -n 's/^PACKAGE_NAME=\([^\n]*\)/\1/p' dkms.conf 2>&1 /dev/null)

dkmsinstall: clean
ifneq ($(shell id -u), 0)
	@echo "You must be root to perform this action."
	exit 1
endif
	cp -R . /usr/src/$(MODULE_NAME)-$(VER)
	dkms install -m $(MODULE_NAME) -v $(VER)

dkmsremove:
ifneq ($(shell id -u), 0)
	@echo "You must be root to perform this action."
	exit 1
endif
	dkms remove -m $(MODULE_NAME) -v $(VER) --all
	rm -rf /usr/src/$(MODULE_NAME)-$(VER)
