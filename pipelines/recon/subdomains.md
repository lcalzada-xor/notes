subfinder -d target.com -all -recursive -silent -o subs.txt

amass enum -passive -d target.com -o amass.txt

chaos -d target.com -o chaos.txt


Validate: cat subs.txt | dnsx -silent -o resolved_subs.txt

