#!/bin/bash
echo "Creating new Docker container"
echo ""
echo "Container name: $1"
echo "Container hostname: $1"
echo "Public key: $3"
echo "Forwarded ports: $2:22"
echo "Forwarded directories: /mnt/projects/$1:/projects"
echo ""

function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}

if [[ "no" == $(ask_yes_or_no "Are you sure?") || \
      "no" == $(ask_yes_or_no "Are you *really* sure?") ]]
then
    echo "Skipped."
    exit 0
fi

echo ""
echo "Creating"

sudo mkdir -p /mnt/projects/$1

sudo docker create \
  --name=$1 \
  --hostname=$1 \
  -e PUBLIC_KEY="$3" \
  -p $2:22 \
  -v /mnt/projects/$1:/projects \
  development-base

echo "Done"