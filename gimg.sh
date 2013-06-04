#!/bin/sh

while getopts f:w:h:n:c: OPT; do
	case $OPT in
	'f')
		FLG_F='TRUE'
		VALUE_F="$OPTARG" ;;
	'w')
		FLG_W='TRUE'
		VALUE_W="$OPTARG" ;;
	'h')
		FLG_H='TRUE'
		VALUE_H="$OPTARG" ;;
	'n')
		FLG_N='TRUE'
		VALUE_N="$OPTARG" ;;
	'c')
		FLG_C='TRUE'
		VALUE_C="$OPTARG" ;;
	esac
done

shift $(( $OPTIND - 1 ))

UA=Mozilla/5
URL=http://www.google.com/images?
URL_OPT="q=$(echo $* | nkf -WwMQ | tr = %)"
TBS_OPT=''

if [ "$FLG_W" = 'TRUE' -o "$FLG_H" = 'TRUE' ]; then
	TBS_OPT="isz:ex,iszw:$VALUE_W,iszh:$VALUE_H"
fi

if [ "$FLG_C" = 'TRUE' ]; then
	case $VALUE_C in
	'color')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:color'
		else
			TBS_OPT="${TBS_OPT},ic:color"
		fi ;;
	'gray')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:gray'
		else
			TBS_OPT="${TBS_OPT},ic:gray"
		fi ;;
	'trans')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:trans'
		else
			TBS_OPT="${TBS_OPT},ic:trans"
		fi ;;
	'red')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:red'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:red"
		fi ;;
	'orange')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:orange'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:orange"
		fi ;;
	'yellow')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:yellow'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:yellow"
		fi ;;
	'green')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:green'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:green"
		fi ;;
	'teal')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:teal'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:teal"
		fi ;;
	'purple')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:purple'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:purple"
		fi ;;
	'pink')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:pink'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:pink"
		fi ;;
	'white')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:white'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:white"
		fi ;;
	'gray')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:gray'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:gray"
		fi ;;
	'black')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:black'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:black"
		fi ;;
	'brown')
		if [ -z "$TBS_OPT" ]; then
			TBS_OPT='ic:specific,isc:brown'
		else
			TBS_OPT="${TBS_OPT},ic:specific,isc:brown"
		fi ;;
	esac
fi

if [ -n "$TBS_OPT" ]; then
	URL_OPT="${URL_OPT}&tbs=${TBS_OPT}"
fi

QUERY=$URL$URL_OPT
echo "$QUERY"

IMG_URLS=$(curl -s -A $UA $QUERY | sed 's/>/>\n/g' | sed 's/?/\n/g' | sed 's/&/\n/g' | sed 's/%/\n/g' | grep imgurl)
if [ "$FLG_N" = 'TRUE' ]; then
	IMG_NUM="$VALUE_N"
else
	IMG_NUM='1'
fi

IMG_URL=$(echo "$IMG_URLS" | sed -n "$IMG_NUM"p | cut -d'=' -f2)
if [ "$FLG_F" = 'TRUE' ]; then
	wget -O $VALUE_F -U $UA $IMG_URL
else
	wget -U $UA $IMG_URL
fi
