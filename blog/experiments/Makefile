.PHONY: preproc compile

all: preproc compile

preproc: test.typ
	# Based on https://github.com/typst/typst/discussions/3278
	# Create a dummy file so Typst doesn't crash on read()
	touch test.typ.result
	# Extract script and interpreter
	meta=$$(typst query test.typ 'metadata' | jq -r '.[0].value'); \
	script=$$(echo $$meta | jq -r '.script.text'); \
	interpreter=$$(echo $$meta | jq -r '.interpreter'); \
	# Run the script and save output \
	echo "$$script" | $$interpreter > test.typ.result;

compile: preproc
	typst compile test.typ test.png
	# 3. Clean up the intermediate file
	rm test.typ.result