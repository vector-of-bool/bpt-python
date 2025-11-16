.SILENT:

lint: format-check
	pyright src/

format:
	ruff format src/

format-check:
	ruff format src/ --check --quiet

test:
	pytest src/

typecheck:
	pyright

build: lint format-check
	uv build

clean:
	rm -vrf -- dist/ .pytest_cache/ .ruff_cache/ $(shell find -name "__pycache__")

clean-build:
	$(MAKE) clean
	$(MAKE) build

INDEX := test-pypi
publish: build
	uv publish --index="$(INDEX)"

many-test: \
	test-python-version(3.13) test-python-version(3.14)

test-python-version(%):
	echo "Testing Python $(%F)"
	uv run --isolated --python "$(%F)" $(MAKE) test
