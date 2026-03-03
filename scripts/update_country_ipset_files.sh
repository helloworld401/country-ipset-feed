#!/usr/bin/env bash
set -euo pipefail

GEOIP_MMDB_URL="${GEOIP_MMDB_URL:-https://git.io/GeoLite2-Country.mmdb}"
COUNTRIES="${COUNTRIES:-RU,BY,AE,TR}"
OUT_DIR="${OUT_DIR:-country_ipsets}"
TMP_DIR="${TMP_DIR:-/tmp/country-ipset-feed}"
MMDB_PATH="${TMP_DIR}/GeoLite2-Country.mmdb"

mkdir -p "$TMP_DIR" "$OUT_DIR"

echo "==> download mmdb"
curl -fsSL --connect-timeout 20 --max-time 180 -o "${MMDB_PATH}.new" "$GEOIP_MMDB_URL"
mv "${MMDB_PATH}.new" "$MMDB_PATH"

python3 - <<'PY'
import os
from pathlib import Path
import maxminddb

mmdb_path = Path(os.environ.get("MMDB_PATH", "/tmp/country-ipset-feed/GeoLite2-Country.mmdb"))
countries = [c.strip().upper() for c in os.environ.get("COUNTRIES", "RU,BY,AE,TR").split(",") if c.strip()]
out_dir = Path(os.environ.get("OUT_DIR", "country_ipsets"))
out_dir.mkdir(parents=True, exist_ok=True)

nets = {cc:set() for cc in countries}
with maxminddb.open_database(str(mmdb_path)) as reader:
    for network, record in reader:
        s = str(network)
        if ":" in s:
            continue
        if not isinstance(record, dict):
            continue
        iso = (record.get("country") or {}).get("iso_code")
        if iso in nets:
            nets[iso].add(s)

for cc in countries:
    p = out_dir / f"{cc}.txt"
    data = "\n".join(sorted(nets[cc]))
    p.write_text(data + ("\n" if data else ""), encoding="utf-8")
    print(f"{cc}: {len(nets[cc])} nets")
PY

{
  echo "updated_at_utc=$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "countries=$COUNTRIES"
  echo "source_mmdb=$GEOIP_MMDB_URL"
} > "${OUT_DIR}/metadata.txt"

echo "done"
