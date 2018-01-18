# Get user data from account names in text file <file> (one account per line) and write to <folder>
# Usage: get_accounts.sh <file> <folder>
# Assumes twarc is installed: https://github.com/DocNow/twarc
DATE=`date +%Y%m%d-%H%M%S`
echo "Getting data for accounts in file $1..."

echo "Output to $2"
if [ ! -d $2 ]; then
  mkdir -p $2;
fi

while read p; do
  if [ ! -f $2/$p.json ]; then
    echo "Getting $p"
    twarc users $p > $2/$p.json
  else
    echo "Skipping $p"
  fi
done <$1

jq -s '.' $2/*.json > $1.json

#generate id file
jq '.[]|.id' $1.json > $1_ids.json

#generate profile URL file
jq '.[]|.entities.description.urls[].expanded_url' $1.json --raw-output > $1_profile_urls.txt



