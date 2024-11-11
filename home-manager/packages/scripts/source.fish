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
