crawl:
katana -u https://target.com -d 5 -js-crawl -silent -o katana_urls.txt

gospider -S final_subs.txt -c 20 -o spider/ --json (js and spas)
cat live_urls.txt | hakrawler -depth 3 -plain > hakrawler_urls.txt
arjun -i live_urls.txt -o arjun.json



pasive:
waymore -i target.com -mode U -o waymore/
gitminer -q "target.com" -o git_urls.txt

gau target.com | tee gau_urls.txt
gauplus target.com | tee gauplus_urls.txt

dupdurl (dedupe urls and params)

alive:
cat clean_urls.txt | httpx -silent -status-code -follow-redirects -o live_urls.txt

classify
gf ssrf < live_urls.txt > ssrf_candidates.txt

brute:
paramspider -d target.com -o paramspider.txt

unify all findings:
cat katana_urls.txt gospider_urls.txt gau_urls.txt gauplus_urls.txt waymore_urls.txt hakrawler_urls.txt paramspider.txt arjun.json | \
    grep "http" | sort -u | uro | httpx -silent -o final_urls.txt
