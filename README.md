---
create_date: 2018-07
archive_date: 2022-08
language: Posix Shell
locale: [en_US]
license: GPLv3
category: [Utility, Linux, Mobile]
dev_status: Archive
---

# Android ROM Repack shell script

## Setup/dependencies

- Install atool ([Arch package](https://archlinux.org/packages/community/any/atool/))
- Get binaries from [this repo](https://github.com/rkhat2/android-rom-repacker) and place them in `./bin`

## Usage
1. Run script with a ROM file as argument like `./repack-rom xiaomi.eu_multi_MI6_8.7.19_v10-8.0.zip`
2. After unpacking/debloating/packing a new ROM file will be created next to the old one with `_new` suffix.
