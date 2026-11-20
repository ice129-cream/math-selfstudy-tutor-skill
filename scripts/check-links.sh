#!/usr/bin/env bash
# 检查仓库内所有 markdown 的相对链接是否存在。纯 bash + grep，无外部依赖。
set -uo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
broken=0
count=0

while IFS= read -r -d '' md; do
  dir="$(dirname "$md")"
  # 抓取 ](...) 里的目标，排除 http(s)/mailto/锚点/空
  while IFS= read -r link; do
    [[ -z "$link" ]] && continue
    [[ "$link" =~ ^(https?://|mailto:) ]] && continue
    target="${link%%#*}"
    [[ -z "$target" ]] && continue
    count=$((count + 1))
    if [[ ! -e "$dir/$target" ]]; then
      printf '断链: %s -> %s\n' "${md#$root/}" "$link"
      broken=$((broken + 1))
    fi
  done < <(grep -oE '\]\([^)]+\)' "$md" | sed 's/^](//; s/)$//')
done < <(find "$root" -name '*.md' -not -path '*/node_modules/*' -print0)

printf '检查了 %d 个相对链接，断链 %d 个\n' "$count" "$broken"
[[ "$broken" -eq 0 ]]
