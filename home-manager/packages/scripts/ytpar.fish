#! /usr/bin/env nix-shell
#! nix-shell -i fish -p yt-dlp

# Define function to get output with clear logging
function get_yt_dlp_filename
    echo "Getting filename for argv[1]: $argv[1]"
    set output (yt-dlp --playlist-items "1:1" --get-filename -o "%(playlist)s" $argv[1])
    if test -z "$output"
        echo "yt-dlp failed to get filename for $argv[1]"
        return 1
    end
    return $output
end

# Check for flags and arguments
set download_type ""
if test "$argv[1]" = -a
    set download_type audio
else if test "$argv[1]" = -v
    set download_type video
else
    echo "Error: No valid flag provided."
    echo "Usage: script [-a] <url> (for audio) | [-v] <url> (for video)"
    exit 1
end

# Get the URL
set url $argv[2]
if test -z "$url"
    echo "Error: No URL provided."
    echo "Usage: script [-a] <url> (for audio) | [-v] <url> (for video)"
    exit 1
end

# Get filename with logging and error handling
set playlist (yt-dlp --playlist-items "1:1" --get-filename -o "%(playlist)s" $url)
if test $status -eq 1
    exit 1
end

# Set the directory based on download type
if test "$download_type" = audio
    set dir ~/Music
else if test "$download_type" = video
    set dir ~/yt
end

echo "Using directory: $dir/$playlist"

# Create and change directory with logging
mkdir -p "$dir/$playlist"
if test $status -eq 1
    echo "Failed to create directory: $dir/$playlist"
    exit 1
end
cd "$dir/$playlist"

if test $status -eq 1
    echo "Failed to enter directory: $dir/$playlist"
    exit 1
end

echo "Current directory: $(pwd)"

# Download with progress based on flag
if test "$download_type" = audio
    echo "Downloading audio from $url..."
    yt-dlp --flat-playlist --get-id $url | sed 's|^|https://www.youtube.com/watch?v=|' | parallel -j 8 --progress yt-dlp \
        -N 8 \
        --embed-thumbnail \
        -f bestaudio \
        -x \
        --audio-quality 0 \
        --add-metadata \
        -ic \
        -o '"%(playlist_index)s - %(title)s.%(ext)s"' \
        {}
else if test "$download_type" = video
    echo "Downloading video from $url..."
    yt-dlp --flat-playlist --get-id $url | sed 's|^|https://www.youtube.com/watch?v=|' | parallel -j 8 --progress yt-dlp \
        -N 8 \
        --embed-thumbnail \
        -f bestvideo+bestaudio \
        --merge-output-format mkv \
        --add-metadata \
        -ic \
        -o '"%(playlist_index)s - %(title)s.%(ext)s"' \
        {}
end
