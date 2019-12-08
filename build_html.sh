#!/bin/sh

# Process MultiMarkdown file into HTML using a responsive CSS design suitable for HTML emails

# Copyright (C) 2019 - Fletcher T. Penney

USAGE="Usage: `basename $0` config_name.json mmd_file.md"

# Ensure we have a file
if [ $# -lt 2 ]; then
	echo $USAGE >&2
	exit 1
fi


# Determine filenames to use
CONFIG=$1

MMDFILE=$2
TEMPFILE=`mktemp tempfile.XXXXXX`
HTMLFILE=${MMDFILE%%.*}.html
JSONFILE=${MMDFILE%%.*}.json


# Convert MMD to HTML
`multimarkdown -t html --full $MMDFILE > $TEMPFILE`

# Process again to handle transclusions inside templates
# Primarily this allows leaving the CSS in a separate file during the creation phase
# Also escape greater-than/less-than again for proper handling in email clients
`multimarkdown -t mmd $TEMPFILE | multimarkdown -t mmd | sed 's/\&lt;/\&amp;lt;/g' | sed 's/\&gt;/\&amp;gt;/g' > $HTMLFILE`


# Cleanup
rm $TEMPFILE


# Files for optionally uploading to sendinblue.com

# Extract metadata to create the JSON file
NAME=`multimarkdown -e campaign $MMDFILE`
SUBJECT=`multimarkdown -e title $MMDFILE`
RECIPIENTS=`multimarkdown -e recipients $MMDFILE`
TAG=`multimarkdown -e tag $MMDFILE`


# Create JSON config file for this campaign
cat $CONFIG | jq --arg tag "$TAG" --arg name "$NAME" --arg subject "$SUBJECT" --arg listIds "$RECIPIENTS"  '. + {name: $name, subject: $subject, recipients: { listIds : [$listIds | tonumber] }, tag :$tag}' > $JSONFILE
