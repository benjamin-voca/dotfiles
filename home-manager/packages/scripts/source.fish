function yt --wraps=yt-dlp\ -N\ 8\ --add-metadata\ -ic\ -f\ \'best\[height\<=1440\]\'+bestaudio\ -o\ \'\~/yt/\%\(playlist\)s/\%\(playlist_index\)s\ -\ \%\(title\)s.\%\(ext\)s\' --description alias\ yt\ yt-dlp\ -N\ 8\ --add-metadata\ -ic\ -f\ \'best\[height\<=1440\]\'+bestaudio\ -o\ \'\~/yt/\%\(playlist\)s/\%\(playlist_index\)s\ -\ \%\(title\)s.\%\(ext\)s\'
    yt-dlp -N 8 --add-metadata -ic -f 'best[height<=1440]'+bestaudio -o '~/yt/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $argv
end

function prepend_tldr
    fish_commandline_prepend tldr
end
bind \et prepend_tldr

function yta --wraps=yt-dlp\ -N\ 8\ --embed-thumbnail\ -f\ bestaudio\ -x\ --audio-quality\ 0\ --add-metadata\ -ic\ -o\ \~/Music/\'\%\(playlist\)s/\%\(playlist_index\)s\ -\ \%\(title\)s.\%\(ext\)s\' --description alias\ yta\ yt-dlp\ -N\ 8\ --embed-thumbnail\ -f\ bestaudio\ -x\ --audio-format\ flac\ --audio-quality\ 0\ --add-metadata\ -ic\ -o\ \~/Music/\'\%\(playlist\)s/\%\(playlist_index\)s\ -\ \%\(title\)s.\%\(ext\)s\'
    yt-dlp -N 8 --embed-thumbnail -f bestaudio -x --audio-quality 0 --add-metadata -ic -o ~/Music/'%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $argv
end

function process_zip
    set dirname (basename -s .zip $argv[1])
    mount-zip $argv[1]
    # echo ./$dirname/(ls -v ./$dirname)
    magick ./$dirname/(ls -v ./$dirname) $dirname.pdf
    fusermount -u $dirname
    echo "$dirname converted"
end

function zip_to_pdf
    echo $argv | tr ' ' '\n' | parallel -j 4 process_zip {}
end

function ytps
    ./ytpar $argv[1]
end

function ytpa
    ./ytpar -a $argv[1]
end

function da
    # Check if a container with the given name exists
    if docker ps -a --format '{{.Names}}' | grep -q "^$argv[1]"
        echo "Container '$argv[1]' already exists. Removing it..."
        docker rm -f $argv[1]
    end

    # Run the container with the provided arguments
    echo "Starting container '$argv[1]'..."
    docker run --name $argv[1] $argv[2..-1]
end

function invertPdf
    nix run nixpkgs#ghostscript -- -o "$argv[1]_dark".pdf -sDEVICE=pdfwrite \
        -c "{1 exch sub} settransfer" -f $argv[1].pdf
end

function append_rg
    # Append "| rg" to the current command line
    commandline -a " | rg"
end

# Bind Alt + r to the append_rg function
bind \er append_rg
