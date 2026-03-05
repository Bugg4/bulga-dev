serve:
	live-server dist --port=8080

watch:
	pwd
	typst watch src/blog.typ --features html --format html --no-serve --no-reload dist/blog.html

clean:
	killall typst || true
	rm -rf dist
