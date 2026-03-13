import os
import sys
import subprocess as sp
import shutil
from concurrent.futures import ProcessPoolExecutor, as_completed
from multiprocessing import cpu_count

ROOT_IN = "content/"
ROOT_OUT = "dist/"

POSTS_OUT_DIR = "posts"

POST_FOLDER_PREFIX = "post-"
POST_EXTENSION = "typ"

FORCE_ALL = False


def is_file_changed(src, dst):
    if FORCE_ALL:
        return True
    if not os.path.exists(dst):
        return True
    return os.path.getmtime(src) > os.path.getmtime(dst)


def copy_file_if_changed(src, dst):
    if is_file_changed(src, dst):
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        shutil.copy2(src, dst)
        return True
    return False


def sync_directory(src_dir, dst_dir):
    """Copies all changed files from src_dir to dst_dir. Returns list of copied files."""
    copied = []
    if not os.path.exists(src_dir):
        return copied

    for root, _, files in os.walk(src_dir):
        for file in files:
            src_file = os.path.join(root, file)
            rel_path = os.path.relpath(src_file, src_dir)
            dst_file = os.path.join(dst_dir, rel_path)
            if copy_file_if_changed(src_file, dst_file):
                copied.append(dst_file)
    return copied


def get_post_info():
    """Returns a list of dicts with post compilation info."""
    posts = []
    if not os.path.exists(ROOT_IN):
        return posts

    for root, dirs, files in os.walk(ROOT_IN):
        # Process standalone .typ files in the root content directory
        if root == ROOT_IN:
            for f in files:
                if f.endswith(f".{POST_EXTENSION}"):
                    file_name = f[: -len(POST_EXTENSION) - 1]  # remove .typ
                    src_file = os.path.join(root, f)
                    dst_html = os.path.join(ROOT_OUT, f"{file_name}.html")

                    posts.append(
                        {
                            "number": "root",
                            "name": file_name,
                            "src_file": src_file,
                            "dst_html": dst_html,
                        }
                    )

        for d in dirs:
            if d.startswith(POST_FOLDER_PREFIX):
                post_number = d[len(POST_FOLDER_PREFIX) :]
                post_dir = os.path.join(root, d)
                for f in os.listdir(post_dir):
                    if f.endswith(f".{POST_EXTENSION}"):
                        post_name = f[: -len(POST_EXTENSION) - 1]  # remove .typ

                        src_file = os.path.join(post_dir, f)
                        dst_html = os.path.join(
                            ROOT_OUT, POSTS_OUT_DIR, post_number, f"{post_name}.html"
                        )

                        src_assets = os.path.join(post_dir, "assets")
                        dst_assets = os.path.join(
                            ROOT_OUT, POSTS_OUT_DIR, post_number, "assets"
                        )

                        posts.append(
                            {
                                "number": post_number,
                                "name": post_name,
                                "src_file": src_file,
                                "dst_html": dst_html,
                                "src_assets": src_assets,
                                "dst_assets": dst_assets,
                            }
                        )
    return posts


def build_post(post):
    src = post["src_file"]
    dst = post["dst_html"]

    if is_file_changed(src, dst):
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        try:
            sp.run(
                [
                    "typstex",
                    "compile",
                    "--allow-exec",
                    src,
                    dst,
                    "--root",
                    ".",
                    "--features",
                    "html",
                    "--format",
                    "html",
                ],
                check=True,
            )
            return f"Built {dst}"
        except sp.TimeoutExpired:
            return f"Error Timeout compiling {src}"
        except sp.CalledProcessError as e:
            return f"Error compiling {src}: returned code {e.returncode}"
        except Exception as e:
            return f"Error compiling {src}:\n{e}"
    return f"Up-to-date {dst}"


def copy_assets_task(post):
    copied = sync_directory(post["src_assets"], post["dst_assets"])
    if copied:
        return f"Copied {len(copied)} asset(s) for post-{post['number']}"
    return f"Assets up-to-date for post-{post['number']}"


def copy_shared_task():
    copied = sync_directory("shared", os.path.join(ROOT_OUT, "shared"))
    if copied:
        return f"Copied {len(copied)} shared file(s)"
    return "Shared files up-to-date"


def copy_styles_task():
    copied = sync_directory("styles", os.path.join(ROOT_OUT, "styles"))
    if copied:
        return f"Copied {len(copied)} style file(s)"
    return "Styles up-to-date"


def main():
    global FORCE_ALL

    if "clean" in sys.argv:
        if os.path.exists(ROOT_OUT):
            for item in os.listdir(ROOT_OUT):
                item_path = os.path.join(ROOT_OUT, item)
                if os.path.isfile(item_path) or os.path.islink(item_path):
                    os.unlink(item_path)
                elif os.path.isdir(item_path):
                    shutil.rmtree(item_path)
            print(f"Cleaned contents of {ROOT_OUT}")
        if "all" not in sys.argv and len(sys.argv) == 2:
            return

    if "all" in sys.argv:
        FORCE_ALL = True

    posts = get_post_info()

    # Determine the number of processes to use
    n_jobs = cpu_count() or 4
    print(f"Running build with {n_jobs} parallel jobs...")

    with ProcessPoolExecutor(max_workers=n_jobs) as executor:
        futures = []

        # 1. Global sync tasks
        futures.append(executor.submit(copy_shared_task))
        futures.append(executor.submit(copy_styles_task))

        # 2. Post-specific tasks
        for post in posts:
            if post["number"] == "root":
                continue  # Build root posts in main thread later
            futures.append(executor.submit(build_post, post))
            if "src_assets" in post and os.path.exists(post["src_assets"]):
                futures.append(executor.submit(copy_assets_task, post))

        # Wait for all tasks to complete and print results
        for future in as_completed(futures):
            try:
                result = future.result()
                if (
                    result
                    and not result.startswith("Up-to-date")
                    and not result.endswith("up-to-date")
                ):
                    print(result)
            except Exception as e:
                print(f"Task failed with error: {e}")

    # 3. Build root posts sequentially in main thread to avoid Typst deadlocks
    for post in posts:
        if post["number"] == "root":
            result = build_post(post)
            if result and not result.startswith("Up-to-date"):
                print(result)


if __name__ == "__main__":
    main()
