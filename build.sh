#!/bin/bash
timestamp() {
  date +"%Y/%m/%d %H:%M:%S"
}

# fetch git
git pull

# build lists, and sort them
# hostlist-compiler -c lostad_filter.json -o lostad_filter.txt
docker run --rm -t -v ~/lostad:/app lennihein/hostlist-compiler hostlist-compiler -c lostad_filter.json -o lostad_filter.txt
sort -o lostad_filter.txt{,}
# hostlist-compiler -c lostad_dns.json -o lostad_dns.txt
docker run --rm -t -v ~/lostad:/app lennihein/hostlist-compiler hostlist-compiler -c lostad_dns.json -o lostad_dns.txt
sort -o lostad_dns.txt{,}
# hostlist-compiler -c lostad.json -o lostad.txt
docker run --rm -t -v ~/lostad:/app lennihein/hostlist-compiler hostlist-compiler -c lostad.json -o lostad.txt
sort -o lostad.txt{,}

# remove empty lines and comments
sed -i '/^$/d' lostad*.txt
sed -i '/^!/d' lostad*.txt

# add update frequency
echo -e "!\n! Expires: 1 day\n!\n$(cat lostad.txt)" > lostad.txt
echo -e "!\n! Expires: 1 day\n!\n$(cat lostad_dns.txt)" > lostad_dns.txt
echo -e "!\n! Expires: 1 day\n!\n$(cat lostad_filter.txt)" > lostad_filter.txt

# add names
echo -e "!\n! Name: LostAd Full\n$(cat lostad.txt)" > lostad.txt
echo -e "!\n! Name: LostAd DNS\n$(cat lostad_dns.txt)" > lostad_dns.txt
echo -e "!\n! Name: LostAd Filter\n$(cat lostad_filter.txt)" > lostad_filter.txt

# add ABP2.0 format
echo -e "[Adblock Plus 2.0]\n$(cat lostad.txt)" > lostad.txt
echo -e "[Adblock Plus 2.0]\n$(cat lostad_filter.txt)" > lostad_filter.txt

# push changes to git
git stage lost*
git commit -m "Build $(timestamp) UTC"
git push
