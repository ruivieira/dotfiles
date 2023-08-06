function notes_move() {
    local md_files=$(find ~/Downloads/obsidian -name "*.jpg" | wc -l)
    if (($md_files > 0)) then
        echo "Found $md_files Markdown files"
        mv ~/Downloads/obsidian/*.md ~/notes/pages/backlog
    else
        echo "No files found"
    fi
	
    local image_files=$(find ~/Downloads/obsidian/images -name "*" | wc -l)
    if (($image_files > 0)) then
        echo "Found $images_files image files"
        trimage -d ~/Downloads/obsidian/images
        mv ~/Downloads/obsidian/*.md ~/notes/pages/backlog
    else
        echo "No files found"
    fi
}

function update_plan() {
    T=`mktemp` && curl -so $T https://plan.cat/~rui && $EDITOR $T && \
    curl -su rui -F "plan=<$T" https://plan.cat/stdin
}

function quarto_render {
    echo "Processing $1"
    quarto render $1
    local base=$1:r
    echo "Do replacements on $base.md"
    sd "<script.*?/script>" "" $base.md
    sd -s "\\[" "[" $base.md
    sd -s "\\]" "]" $base.md
    # sd "<img src=\\"(.*?)\\".*/>" '![[$1]]' $base.md
    sd -s "%20" " " $base.md
    sd -s "\\|" "|" $base.md
}

local DENO_RUN="deno run -A --unstable ~/Sync/code/deno/deno-experiments"

alias agile="${DENO_RUN}/agile/agile.ts"
alias humble="${DENO_RUN}/humble/humble.ts"