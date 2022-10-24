all: shellcheck test

shellcheck:
	shellcheck rp test.sh

test:
	bash test.sh

.PHONY: all shellcheck test
