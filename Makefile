all: shellcheck test

shellcheck:
	shellcheck --severity=info rp test.sh

test:
	bash test.sh

.PHONY: all shellcheck test
