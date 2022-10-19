shellcheck:
	shellcheck rp test.sh

test:
	bash test.sh

.PHONY: shellcheck test
