# LostAd

consolidated Content Filter and DNS Hostlist

## List to choose
|                                             |                                                                                          |                                                          |
|---------------------------------------------|------------------------------------------------------------------------------------------|----------------------------------------------------------|
| AdGuard / uBlock Origin / AdBlockPlus       | [LostAd Full](https://raw.githubusercontent.com/lennihein/LostAd/main/lostad.txt)         | [Automated Install](https://lennihein.github.io/LostAd/) |
| AdGuardHome / PiHole / NextDns / AdGuardDns | [LostAd DNS](https://raw.githubusercontent.com/lennihein/LostAd/main/lostad_dns.txt) |                                                          |
| Adguard for Windows | [LostAd Filter](https://raw.githubusercontent.com/lennihein/LostAd/main/lostad_filter.txt) + [LostAd DNS](https://raw.githubusercontent.com/lennihein/LostAd/main/lostad_dns.txt) | [Automated Install](https://lennihein.github.io/LostAd/)

## Comparison using Chrome

Blocker | D3ward Test | adblock-tester.com | TheGuardian Cookie | NYT Cookie | CYB Content Blocker | CYB Adblock Detector | CYB Alternate Content 
---|---|---|---|---|---|---|---
Without Blocker | 12% | 47pts | ❌ | ❌ | ❌ | ❌ | ❌ 
AdBlock | 39% | 78pts | ❌ | ❌ | ❌ | ❌ | ❌ 
AdBlockPlus | 39% | 78pts | ❌ | ❌ | ❌ | ❌ | ❌ 
Brave Browser | 78% | 100pts | ❌ | ❌ | ❌ | ❌ | ❌
AdGuard Extension | 43% | 84pts | ❌ | ❌ | ✅ | ❌ | ✅
uBlock Origin | 89% | 96pts | ❌ | ❌ | ✅ | ❌ | ✅
AdGuard Home + LostAd DNS | 100% | 83pts | ✅ | ❌ | ✅ | ✅ | ✅[^1]
LostAd Full [^2] | 100% | 100pts | ✅ | ✅ | ✅ | ✅ | ✅  

[^1]: ad is blocked, but empty space remains
[^2]: same results independent of tested extension

## The threat of MV3

Blocker | D3ward Test | adblock-tester.com | TheGuardian Cookie | NYT Cookie | CYB Content Blocker | CYB Adblock Detector | CYB Alternate Content 
---|---|---|---|---|---|---|---
Without Blocker | 12% | 47pts | ❌ | ❌ | ❌ | ❌ | ❌ 
AdGuard MV3 | 44% | 84pts | ❌ | ❌ | ❌ | ❌ | ✅ 
uBlock Origin Minus | 85% | 100pts | ❌ | ❌ | ✅ | ❌ | ✅[^1]
AdGuard MV3 + LostCustom | 78% | 100pts | ✅ | ✅ | ✅ | ✅ | ✅  
AdGuard MV3 + LostCustom and AdGuard Home + LostAd DNS | 100% | 100pts | ✅ | ✅ | ✅ | ✅ | ✅  
