#!/usr/bin/env bash
# 用 Google DoH 检查规则里的域名是否存在（绕开本机 fake-ip DNS）
# 用法：scripts/check.sh [rules/xxx.txt ...]，默认检查 rules/ 下全部文件
set -euo pipefail
cd "$(dirname "$0")/.."

files=("$@")
[ ${#files[@]} -eq 0 ] && files=(rules/*.txt)

fail=0
for f in "${files[@]}"; do
  while IFS=, read -r type domain _; do
    case "$type" in DOMAIN|DOMAIN-SUFFIX) ;; *) continue ;; esac
    status=$(curl -s -m 10 "https://dns.google/resolve?name=${domain}&type=A" |
      python3 -c 'import sys,json; print(json.load(sys.stdin).get("Status","?"))' 2>/dev/null || echo "?")
    if [ "$status" = "0" ]; then
      printf 'ok    %s\n' "$domain"
    else
      printf 'FAIL  %s (status=%s) in %s\n' "$domain" "$status" "$f"
      fail=1
    fi
  done < <(grep -vE '^\s*(#|$)' "$f")
done
exit $fail
