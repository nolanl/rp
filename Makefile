all: shellcheck test

shellcheck:
	shellcheck --severity=info rp test.sh

test:
	bash test.sh

sshtest:
	SSHTEST=1 bash test.sh

.PHONY: all shellcheck test
