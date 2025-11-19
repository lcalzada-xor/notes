# Cloud Asset Discovery Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.
> Example: `export TARGET_NAME="example" # Base name of the company`

## 1. Cloud Enumeration
Search for public buckets and storage blobs using keyword permutations.

```bash
# Cloud Enum (Multi-cloud)
cloud_enum -k $TARGET_NAME -l scans/cloud_enum_results.txt

# AWS Recon (if you have specific keywords)
# aws-recon ... (requires setup)
```

## 2. S3 Bucket Hunting
Specifically target AWS S3 buckets.

```bash
# S3Scanner
s3scanner scan --bucket $TARGET_NAME

# GrayhatWarfare (Public API search)
# Search manually or via API for "$TARGET_NAME"
```

## 3. DNS Analysis for Cloud Services
Check CNAME records for cloud provider signatures.

```bash
# DNSTwist or simple dig checks
# Look for:
# .s3.amazonaws.com
# .azurewebsites.net
# .herokuapp.com
# .cloudfront.net

cat final_resolved_subs.txt | dnsx -cname -resp -silent | grep -E "amazonaws|azure|google|herokuapp|cloudfront" > cloud_cnames.txt
```

## 4. Azure Blob Hunting
Specific checks for Azure Storage.

```bash
# MicroBurst (PowerShell) or similar tools
# Invoke-EnumerateAzureBlobs -Base $TARGET_NAME
```
