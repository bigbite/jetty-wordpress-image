#!/usr/bin/env bash

# if no file supplied, exit
if [[ ! -f "$1" ]]; then
	>&2 echo "File does not exist, or was not specified.";
	exit 1;
fi

# check whether verbose output is enabled
declare -a positional_args;
while [[ $# -gt 0 ]]; do
	case $1 in
		--verbose|-v)
			verbose=1;
			shift;
		;;
		--*|-*)
			>&2 echo "Unknown option $1";
			exit 1;
		;;
		*)
			positional_args+=("$1");
			shift;
		;;
	esac
done
set -- "${positional_args[@]}";

# output verbose messages
function verbose() {
	if [ $verbose ]; then
		>&2 echo "$1";
	fi
}

# create an array to store our list of image strings
declare -a images;

# read file one line at a time.
# each line contains the following:
# wp.version: [php.version1,php.version2 ...]
while IFS= read -r line; do
	verbose 'Reading line:';
	verbose "- $line";

	# line is keyed by wp version, so everything before the first semicolon is the wp version.
	wpVersion=$(echo "$line" | awk -F':' '{print $1}');
	verbose "- - WP Version: $wpVersion";

	# value for each line is an array of php versions, so everything after the semicolon is the array
	# use sed to strip anything that isn't a number, comma, or period, which leaves a csv of php versions
	phpVersions=$(echo "$line" | awk -F':' '{print $2}' | sed 's/[^0-9.,]//g');
	verbose "- - PHP Versions: $phpVersions";

	# split the php versions into an array by "exploding" on the comma
	IFS=',' read -r -a phpVersions <<< "$phpVersions"

	# for each version in the array
	for php in "${phpVersions[@]}"; do
		verbose "- - - Using PHP Version: $php";

		# build the image name
		image=$(printf '%s-php%s' "$wpVersion" "$php");
		verbose "- - - Image Name: $image";

		# build the json entry for the image name, and add to an array of images
		images+=("$(printf '{ "tag": "%s", "args": { "WORDPRESS_IMAGE": "%s" } }' "$image" "$image")");
		verbose "- - Generated JSON Entry: $(printf '{ "tag": "%s", "args": { "WORDPRESS_IMAGE": "%s" } }' "$image" "$image")";
	done;
done < "$1";

# start building the json!
verbose 'Building JSON';
json='';

# for each found image
for ((i = 0; i < "${#images[@]}"; i++)); do
	# add to the json string
	json=$(printf "%s,\n    %s" "$json" "${images[$i]}");
done

# wrap the string in an array to make it valid (lose the leading delims.)
printf "[\n%s\n]" "${json:2}"