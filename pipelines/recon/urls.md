# URL Discovery Pipeline

> **Tip:** If you used `setup_audit.sh`, you can use the `target` file.
> Example: `export TARGET=$(cat target)`

## 1. Passive Collection
Gather URLs from archives and OINT.

```bash
# Waymore (Wayback Machine + Common Crawl + AlienVault)
waymore -i $(cat target | sed 's|https://||') -mode U -o waymore_results/

# GAU (Get All Urls)
gau --blacklist png,jpg,gif,css,woff,svg $(cat target | sed 's|https://||') | tee gau_urls.txt

# Gauplus
gauplus -t 5 -random-agent -subs $(cat target | sed 's|https://||') | tee gauplus_urls.txt

# Gitminer
gitminer -q "$(cat target | sed 's|https://||')" -o git_urls.txt
```

## 2. Active Crawling
Crawl the live site to find hidden links.

```bash
# Katana (Modern, fast crawler)
katana -u $TARGET -d 5 -js-crawl -known-files all -silent -o katana_urls.txt

# GoSpider
gospider -S live_subdomains.txt -c 10 -d 3 --other-source --include-subs -o gospider_results/

# Hakrawler (Simple, pipe-friendly)
cat live_subdomains.txt | hakrawler -depth 3 -plain > hakrawler_urls.txt
```

## 3. Parameter Discovery
Find hidden parameters.

```bash
# Arjun
arjun -i live_subdomains.txt -o arjun_output.json

# ParamSpider
paramspider -d $(cat target | sed 's|https://||') -o paramspider.txt
```

## 4. Unify & Clean
Merge all lists, remove duplicates, and filter out noise.

```bash
# Combine all files
cat waymore_results/*.txt gau_urls.txt gauplus_urls.txt katana_urls.txt hakrawler_urls.txt paramspider.txt | sort -u > all_raw_urls.txt

# Uro (URL de-duplication and cleaning)
cat all_raw_urls.txt | uro > clean_urls.txt

# Filter for interesting extensions (optional)
cat clean_urls.txt | grep -E "\.php|\.asp|\.jsp|\.json|\.action|\.do" > interesting_urls.txt
```

## 5. Live Check
Verify which URLs are actually accessible.

```bash
cat clean_urls.txt | httpx -silent -status-code -follow-redirects -mc 200,301,302,403 -o live_urls.txt
```

## 6. Next Steps
- **JavaScript Analysis**: Go to [js_analysis.md](js_analysis.md)
- **Fuzzing**: Go to [fuzzing.md](fuzzing.md)
- **Vulnerability Scanning**: Go to `../vulns/nuclei/nuclei.md`
