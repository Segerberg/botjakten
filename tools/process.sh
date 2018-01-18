# 1. Rensa dubletter
sort -u bots1.txt > bots1_clean.txt

# 2. Hämta kontodata och skapa lista av id:n
./get_accounts.sh bots1_clean.txt bots1data

# 3. Filtrera bort konton > 100 följare
jq '[.[]|select(.followers_count < 100)]' bots1_clean.txt.json > bots1_lte_100_followers.json

# 4. Platta ut vissa grunddata för enklare analys i Tableau, Excel etc
echo "id_str,screen_name,default_profile,followers_count,favourites_count,statuses_count,lang,created_at" > bots1_lte_100_followers.csv
jq -r '.[]|[.id_str,.screen_name,.default_profile,.followers_count,.favourites_count,.statuses_count,.lang,.created_at]|@csv' bots1_lte_100_followers.json >> bots1_lte_100_followers.csv

# 5. Läs ut profillänkars målsidor
jq '.[]|.entities.description.urls[].expanded_url?' bots1_lte_100_followers.json --raw-output > bots1_lte_100_followers_profile_urls.txt

cat bots1_lte_100_followers_profile_urls.txt|parallel ./expandurl.sh > bots1_clean_expandednurls.csv

# 4. lista konton skapade ett visst år och skapa mosaik av deras profilbilder
jq -r '.[]|select(.followers_count < 100)|select(.created_at|contains("2011"))|[.screen_name,.profile_image_url_https]|join(", ")' bots1_clean.txt.json >2011bot/profile.csv

while IFS=, read -r screenname url
do
  wget -O 2011bot/$screenname.jpg $url
done < 2011bot/profile.csv

./mosaic.sh 2011bot
