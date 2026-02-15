# Linux SYN Rate-Limit Firewall (nftables)

## Overview
This project implements host-based firewall protection on Ubuntu Linux using nftables.  
It detects excessive TCP SYN packet rates and automatically blacklists offending IP addresses.

Designed as a Blue Team / SOC defensive control demonstration.

## Features
- SYN packet rate monitoring
- Automatic IP blacklisting
- Timeout-based ban expiry
- Kernel-level packet filtering
- Low-overhead rule processing

## Detection Logic
If a source IP exceeds the configured SYN rate threshold, it is automatically added to a blacklist set and blocked for a defined timeout period.

Example threshold:
- More than 5 SYN packets per minute → block for 1 hour

## Script
`syn_guard_nft.sh` creates:
- nftables table
- blacklist set
- rate meter
- drop rules

## Run

```bash
sudo bash syn_guard_nft.sh

## Check Blacklisted IPs

sudo nft list set inet synprotect blacklist

## Remove IP manually fro Blacklist

sudo nft delete element inet syprotect blacklist {1.2.3.4} --> the IP

## Adjust Limits If Needed

##Change this in the bash
limit rate over 5/minute
timeout 1h

## Disable 
sudo nft delete table inet synprotect
