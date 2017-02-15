# THIS IS USELESS NOW
# I'M DOING "yum install unzip" IN THE DOCKERFILE

#!/bin/bash

TMP_DIR=$(mktemp -d)

if [ $# -ne 1 ]
then
  echo "You forgot to tell me which zip archive to repackage." ; echo
  exit 1
else
  echo "Extracting zip..."
  unzip -d $TMP_DIR $1
  echo "Creating new archive..."
  tar czvf $1.tgz -C $TMP_DIR .
fi

rm -rf $TMP_DIR

# BASH string manipulation, remove .zip extension
#http://stackoverflow.com/questions/11265381/how-to-delete-everything-in-a-string-after-a-specific-character
