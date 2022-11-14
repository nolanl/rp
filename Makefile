all: check test

check:
	shellcheck -e SC2129 rp test.sh

test:
	bash test.sh

sshtest:
	SSHTEST=1 bash test.sh

.PHONY: all check test
