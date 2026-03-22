// Include all content files
#include "src/index.typ"
#include "src/posts/post-001.typ"
// #include "src/posts/post-002.typ"

// Relative to dist.typ
#let STYLES_SRC_DIR = "./src/styles/"
#let SHARED_SRC_DIR = "./src/shared/"
#let POSTS_SRC_DIR = "./src/posts/"

// Relative to dist/ which will be new root
#let STYLES_OUT_DIR = "styles/"
#let SHARED_OUT_DIR = "shared/"
#let POSTS_OUT_DIR = "posts/" // we don't rellay need this here

// Build assets lists
#let stylesheets = (
  "blog.css",
)

#let shared_files = (
  "favicon.png",
)

// Copy assets as is
// NOTE: Currently this would not work for nested folders
#for s in stylesheets {
  asset(STYLES_OUT_DIR + s, read(STYLES_SRC_DIR + s))
}

// NOTE: Currently this would not work for nested folders
#for f in shared_files {
  asset(SHARED_OUT_DIR + f, read(SHARED_SRC_DIR + f, encoding: none))
}

#asset("CNAME", read("./src/CNAME", encoding: none))
