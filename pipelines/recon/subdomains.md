# Subdomain Discovery Pipeline

> **Tip:** If you used `setup_audit.sh`, you can use the `target` file.
> Example: `export TARGET=$(cat target | sed 's|https://||')`

## 1. Passive Enumeration
Gather subdomains from public sources without interacting directly with the target.

```bash
# Subfinder
subfinder -d $TARGET -all -recursive -silent -o subfinder.txt

# Amass (Passive)
amass enum -passive -d $TARGET -o amass.txt

# Chaos
chaos -d $TARGET -o chaos.txt

# Github (Gitminer/Github-subdomains)
github-subdomains -d $TARGET -t tokens.txt -o github.txt
```

## 2. Active Enumeration
Brute-force subdomains using a wordlist.

```bash
# ShuffleDNS or PureDNS with a good wordlist
puredns bruteforce best-dns-wordlist.txt $TARGET -r resolvers.txt -w active_brute.txt
```

## 3. Comprehensive Scan (BBOT)
Use BBOT for an all-in-one recursive scan (Passive + Active).

```bash
# BBOT (Recursive, passive, active, cloud)
bbot -t $TARGET -f subdomain-enum -o bbot_results
cat bbot_results/subdomains.txt >> all_subs_so_far.txt
```

## 4. Permutations & Alterations
Generate variations of known subdomains to find more.

```bash
# Combine all found so far
cat subfinder.txt amass.txt chaos.txt github.txt active_brute.txt | sort -u > all_subs_so_far.txt

# Altdns or Gotator
gotator -sub all_subs_so_far.txt -perm permutations_list.txt -depth 1 -numbers 10 -mindup -adv -md > gotator_perms.txt
```

## 5. DNS Resolution & Validation
Verify which subdomains actually resolve to an IP.

```bash
# Combine everything
cat all_subs_so_far.txt gotator_perms.txt | sort -u > all_candidates.txt

# Resolve with Puredns or ShuffleDNS
puredns resolve all_candidates.txt -r resolvers.txt -w resolved_subs.txt

# Or use dnsx
cat all_candidates.txt | dnsx -silent -a -aaaa -cname -ns -o dns_details.txt
cat dns_details.txt | cut -d " " -f1 | sort -u > final_resolved_subs.txt
```

## 6. Visual Reconnaissance
Take screenshots of all live subdomains to quickly spot interesting targets.

```bash
# Gowitness
gowitness file -f final_resolved_subs.txt --screenshot-fullpage

# Aquatone
cat final_resolved_subs.txt | aquatone -out screenshots/
```

## 7. Next Steps
- **Port Scanning**: Go to [ports.md](ports.md)
- **Cloud Discovery**: Go to [cloud.md](cloud.md)
