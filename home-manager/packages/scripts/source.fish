function yt --wraps=yt-dlp\ -N\ 8\ --add-metadata\ -ic\ -f\ \'best\[height\<=1440\]\'+bestaudio\ -o\ \'\~/yt/\%\(playlist\)s/\%\(playlist_index\)s\ -\ \%\(title\)s.\%\(ext\)s\' --description alias\ yt\ yt-dlp\ -N\ 8\ --add-metadata\ -ic\ -f\ \'best\[height\<=1440\]\'+bestaudio\ -o\ \'\~/yt/\%\(playlist\)s/\%\(playlist_index\)s\ -\ \%\(title\)s.\%\(ext\)s\'
    yt-dlp -N 8 --add-metadata -ic -f 'best[height<=1440]'+bestaudio -o '~/yt/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $argv
end

function prepend_tldr
    fish_commandline_prepend tldr
end
bind \et prepend_tldr

function yta --wraps=yt-dlp\ -N\ 8\ --embed-thumbnail\ -f\ bestaudio\ -x\ --audio-format\ flac\ --audio-quality\ 0\ --add-metadata\ -ic\ -o\ \~/Music/\'\%\(playlist\)s/\%\(playlist_index\)s\ -\ \%\(title\)s.\%\(ext\)s\' --description alias\ yta\ yt-dlp\ -N\ 8\ --embed-thumbnail\ -f\ bestaudio\ -x\ --audio-format\ flac\ --audio-quality\ 0\ --add-metadata\ -ic\ -o\ \~/Music/\'\%\(playlist\)s/\%\(playlist_index\)s\ -\ \%\(title\)s.\%\(ext\)s\'
    yt-dlp -N 8 --embed-thumbnail -f bestaudio -x --audio-format flac --audio-quality 0 --add-metadata -ic -o ~/Music/'%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $argv
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

function ytp

    # Capture all variables in a single call
    set -l output (yt-dlp --get-filename -o '%(playlist)s|%(playlist_index)s|%(title)s|%(ext)s' $argv[2])

    # Split the output into individual parts
    set -l parts (string split '|' $output)

    # Assign parts to variables
    set -l playlist $parts[1]
    set -l playlist_index $parts[2]
    set -l title $parts[3]
    set -l ext $parts[4]

    switch $argv[3]
        case audio
            set -l dir "~/Music/"
        case video
            set -l dir "~/yt/"
    end


    mkdir "$dir/$playlist/"
    cd "$dir/$playlist"
    pwd

    yt-dlp --flat-playlist --get-id $argv[2] | sed 's|^|https://www.youtube.com/watch?v=|' | parallel -j 8 $argv[1] {}
end

function ytps
    ytp yt-dlp -N 8 --add-metadata -ic -f bestvideo+bestaudio $argv[1] video
end

function ytpa
    ytp -N 8 --embed-thumbnail -f bestaudio -x --audio-format flac --audio-quality 0 --add-metadata -ic $argv[1] audio
end
