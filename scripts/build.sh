#!/usr/bin/env bash
# 由 rules/*.txt 生成 Quantumult X 格式到 quantumultx/*.list
# DOMAIN → HOST，DOMAIN-SUFFIX → HOST-SUFFIX，DOMAIN-KEYWORD → HOST-KEYWORD，策略统一写 DIRECT（可用 force-policy 覆盖）
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p quantumultx

for src in rules/*.txt; do
  out="quantumultx/$(basename "$src" .txt).list"
  {
    echo "# 由 $src 生成，请勿直接修改"
    sed -E \
      -e 's/^DOMAIN-SUFFIX,([^,]+).*/HOST-SUFFIX,\1,DIRECT/' \
      -e 's/^DOMAIN-KEYWORD,([^,]+).*/HOST-KEYWORD,\1,DIRECT/' \
      -e 's/^DOMAIN,([^,]+).*/HOST,\1,DIRECT/' \
      -e 's/^IP-CIDR,([^,]+).*/IP-CIDR,\1,DIRECT/' \
      -e 's/^IP-CIDR6,([^,]+).*/IP6-CIDR,\1,DIRECT/' \
      "$src"
  } > "$out"
  echo "built $out"
done
