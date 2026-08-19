# LostAd

A highly effective consolidated **content filter** and **DNS hostlist**, optimized for AdGuard, uBlock Origin, Pi-hole, AdGuard Home, and more.

**To install LostAd, visit the [install page](https://adblock.lennihein.com/install.html).**

---

## 📊 Real-World Comparison (Chrome)

| Blocker                                 | D3ward Test | adblock-tester.com | TheGuardian Cookie | NYT Cookie | CYB Content Blocker | CYB Adblock Detector | CYB Alternate Content |
|-----------------------------------------|-------------|---------------------|---------------------|------------|----------------------|------------------------|------------------------|
| Without Blocker                         | 12%         | 47pts               | ❌                  | ❌         | ❌                   | ❌                     | ❌                     |
| AdBlock                                 | 39%         | 78pts               | ❌                  | ❌         | ❌                   | ❌                     | ❌                     |
| AdBlockPlus                             | 39%         | 78pts               | ❌                  | ❌         | ❌                   | ❌                     | ❌                     |
| Brave Browser                           | 78%         | 100pts              | ❌                  | ❌         | ❌                   | ❌                     | ❌                     |
| AdGuard Extension                       | 43%         | 84pts               | ❌                  | ❌         | ✅                   | ❌                     | ✅                     |
| uBlock Origin                           | 89%         | 96pts               | ❌                  | ❌         | ✅                   | ❌                     | ✅                     |
| AdGuard Home + LostAd DNS               | 100%        | 83pts               | ✅                  | ❌         | ✅                   | ✅                     | ✅[^1]                 |
| **LostAd Full**[^2]                     | **100%**    | **100pts**          | ✅                  | ✅         | ✅                   | ✅                     | ✅                     |

[^1]: Ad is blocked, but the empty placeholder remains
[^2]: Same results across extensions — performance is list-driven
