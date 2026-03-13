BLOG_SRC := content/
BLOG_DIST := dist/
POST_OUT_DIR := posts

# Notice the added hyphen here so the stem strictly captures "001"
POST_FOLDER_PREFIX := post-
POST_EXTENSION := typ

# 1. Compile Typst Files 
# Maps content/post-001/some-title.typ -> .dist/posts/001/some-title.html
POST_FILES := $(wildcard $(BLOG_SRC)$(POST_FOLDER_PREFIX)*/*.$(POST_EXTENSION))
HTML_FILES := $(patsubst $(BLOG_SRC)$(POST_FOLDER_PREFIX)%.$(POST_EXTENSION), $(BLOG_DIST)$(POST_OUT_DIR)/%.html, $(POST_FILES))

# 2. Post Assets
# Maps content/post-001/assets/pic.jpg -> .dist/posts/001/assets/pic.jpg
ASSET_FILES := $(shell find $(BLOG_SRC) -path "*/assets/*" -type f 2>/dev/null)
ASSET_TARGETS := $(patsubst $(BLOG_SRC)$(POST_FOLDER_PREFIX)%, $(BLOG_DIST)$(POST_OUT_DIR)/%, $(ASSET_FILES))

# 3. Styles 
# Maps styles/blog.css -> .dist/styles/blog.css
STYLE_FILES := $(shell find styles -type f 2>/dev/null)
STYLE_TARGETS := $(patsubst styles/%, $(BLOG_DIST)styles/%, $(STYLE_FILES))

SHARED_FILES := $(shell find shared -type f 2>/dev/null)
SHARED_TARGETS := $(patsubst shared/%, $(BLOG_DIST)shared/%, $(SHARED_FILES))

.PHONY: all build clean copy-assets copy-styles serve

serve:
	live-server .dist & disown

# Main target
all: build copy-assets copy-styles copy-shared

build: $(HTML_FILES)

copy-assets: $(ASSET_TARGETS)

copy-styles: $(STYLE_TARGETS)

copy-shared: $(SHARED_TARGETS)

# --- Pattern Rules ---

# Rule for compiling Typst (strips 'post-' via the pattern match)
$(BLOG_DIST)$(POST_OUT_DIR)/%.html: $(BLOG_SRC)$(POST_FOLDER_PREFIX)%.$(POST_EXTENSION)
	@mkdir -p $(dir $@)
	typstex compile --allow-exec $< $@ --root . --features html --format html

# Rule for copying post assets (strips 'post-' via the pattern match)
$(BLOG_DIST)$(POST_OUT_DIR)/%: $(BLOG_SRC)$(POST_FOLDER_PREFIX)%
	@mkdir -p $(dir $@)
	cp $< $@

# Rule for copying styles
$(BLOG_DIST)styles/%: styles/%
	@mkdir -p $(dir $@)
	cp $< $@

# Rule for copying shared files
$(BLOG_DIST)shared/%: shared/%
	@mkdir -p $(dir $@)
	cp $< $@

clean:
	rm -rf $(BLOG_DIST)