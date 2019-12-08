#!/bin/sh

# Upload HTML file to sendinblue.com for mailing to your audience

# Copyright (C) 2019 - Fletcher T. Penney


USAGE="Usage: `basename $0` the_campaign.json the_campaign.html"

# Ensure we have a file
if [ $# -lt 2 ]; then
	echo $USAGE >&2
	exit 1
fi


# Determine filenames to use
CONFIG=$1

HTMLFILE=$2

API=$(<api.key)

if [ $API == "" ]; then
	echo "Please configure api.key"
	exit 1
fi

cat $CONFIG | jq --arg htmlContent "$(<$HTMLFILE)" '.htmlContent=$htmlContent' \
| curl -H "$API" -H 'Content-Type: application/json' \
-X POST -d @- 'https://api.sendinblue.com/v3/emailCampaigns'
