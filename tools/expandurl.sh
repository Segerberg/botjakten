# Expand a URL (e.g. link shortener URL) through all redirects and print the
# URL and final domain name separated by a comma.
URL=$1
printf "${URL}, "
EXPANDURL=$(curl -Ls -o /dev/null -w %{url_effective} "${URL}"|awk -F/ '{print $3}')
printf "${EXPANDURL}\n"
