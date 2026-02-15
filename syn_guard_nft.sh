#!/bin/bash

# Create table if missing
nft list table inet synprotect >/dev/null 2>&1 || \
nft add table inet synprotect

# Create blacklist set (auto-expires entries)
nft list set inet synprotect blacklist >/dev/null 2>&1 || \
nft add set inet synprotect blacklist { type ipv4_addr\; timeout 1h\; }

# Create input chain hooked to firewall
nft list chain inet synprotect input >/dev/null 2>&1 || \
nft add chain inet synprotect input { type filter hook input priority 0 \; }

# Drop already blacklisted IPs
nft add rule inet synprotect input ip saddr @blacklist drop 2>/dev/null

# Rate check SYN → add to blacklist if over 5/min
nft add rule inet synprotect input tcp flags syn \
  meter syn_meter { ip saddr limit rate over 5/minute } \
  add @blacklist { ip saddr } drop 2>/dev/null

echo "SYN rate guard active (nftables)"

