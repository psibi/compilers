# List all recipies
default:
    just --list --unsorted

# Generate chapters
build:
    cp -r images src/
    fd --type file --extension org --strip-cwd-prefix | awk 'BEGIN { FS="."} {print $1}' | xargs -I {} pandoc --to=commonmark {}.org -o src/{}.md
    mv src/SUMMARY.md src/SUMMARY_dup.md
    cat src/SUMMARY_dup.md | awk '{gsub(/.org/,".md"); print}' > src/SUMMARY.md

# Serve book
serve:
    mdbook serve --dest-dir ./docs

# Clean markdown files
clean:
    rm src/cha*.md

# Add images as git lfs
lfs-images:
    git lfs track images/*png
    git lfs track src/images/*png
    git lfs track docs/images/*png
