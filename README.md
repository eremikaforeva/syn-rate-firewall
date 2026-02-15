# SYN Rate-Limit Firewall (nftables)

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


## Architecture Overview

                ┌────────────────────┐
Incoming Traffic│  External Network   │
                └─────────┬──────────┘
                          │
                          ▼
                ┌────────────────────┐
                │ Linux Host Firewall │
                │     (nftables)      │
                └─────────┬──────────┘
                          │
          ┌───────────────┼────────────────┐
          │                                │
          ▼                                ▼
 SYN Rate Meter                     Normal Traffic
 (per source IP)                    Allowed Through
          │
          ▼
Rate Threshold Exceeded?
          │
     Yes ─┴─ No
      │        │
      ▼        ▼
Add IP to     Accept
Blacklist
(set with
timeout)
      │
      ▼
Drop Packets
from Source


## Detection & Response Flow

1. Firewall inspects incoming TCP packets
2. SYN packets are measured per source IP
3. If SYN rate exceeds threshold:
   - Source IP added to nftables blacklist set
   - Packets dropped automatically
4. Blacklist entries expire after timeout
5. Legitimate traffic continues normally

## SOC Relevance

This architecture demonstrates:

- Host-based intrusion prevention
- Automated defensive response
- Network abuse detection
- Rate-based anomaly control
- Blue-team firewall engineering



