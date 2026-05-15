# Filesystems

## ext4

- Default Linux filesystem. Journaling modes: journal, ordered, writeback.
- Features: extents, delayed allocation, inline data, dir_index, project
  quotas, fscrypt, fs-verity.
- Tools: `tune2fs`, `e2fsck`, `dumpe2fs`.
- Common mount options: `noatime`, `relatime`, `data=ordered`, `barrier=1`,
  `discard`, `errors=remount-ro`.
- Tune reserved blocks with `tune2fs -m`; prefer periodic `fstrim.timer` over
  continuous discard for most SSD workloads.

## xfs

- High-performance journaling filesystem for large files and parallel I/O.
- Features: allocation groups, delayed allocation, reflinks, online grow,
  online defrag, project quotas.
- Tools: `xfs_admin`, `xfs_repair`, `xfs_info`, `xfs_fsr`, `xfs_quota`.
- Common mount options: `noatime`, `inode64`, `logbsize=256k`, `allocsize=64m`,
  `discard` or `nodiscard`.
- Cannot shrink online or offline in normal operation.

## btrfs

- Copy-on-write filesystem with integrated volume management.
- Features: subvolumes, snapshots, send/receive, transparent compression,
  checksumming, online resize, qgroups.
- Tools: `btrfs subvolume`, `btrfs balance`, `btrfs scrub`,
  `btrfs filesystem usage`, `btrfs device`.
- Common mount options: `compress=zstd:3`, `space_cache=v2`, `autodefrag`,
  `noatime`, `subvol=/@`, `ssd`.
- Caveats: RAID5/6 still has write-hole concerns. Swapfiles require nocow and
  single-extent allocation.

## tmpfs

- RAM-backed filesystem with swap fallback. Common for `/tmp`, `/run`,
  `/dev/shm`, build scratch space.
- Options: `size=2G`, `nr_inodes=1M`, `mode=1777`, `noexec`, `nosuid`,
  `nodev`, `huge=always|within_size|advise|never`.
- Supports POSIX xattrs.

## overlayfs

- Union filesystem used by container runtimes and immutable base plus writable
  state designs.
- Mount form:

```sh
mount -t overlay overlay \
  -o lowerdir=/lower,upperdir=/upper,workdir=/work /merged
```

- Workdir must be on the same filesystem as upperdir.
- Semantics: copy-up on write, whiteouts for deletes, opaque dirs for replaced
  directories.
- Options: `redirect_dir=on`, `metacopy=on`, `index=on`, `nfs_export=on`.

## squashfs

- Read-only compressed filesystem for live media, snaps, AppImages, initramfs,
  and immutable images.
- Create with `mksquashfs source output.squashfs -comp zstd`.
- Compression: gzip, lzo, lz4, xz, zstd.
- Often paired with overlayfs for writable state.

## NFS

- NFSv4 uses TCP/2049, supports Kerberos, ACLs, and a single pseudo-root.
- Server exports use `sync` or `async`, `root_squash` or `no_root_squash`,
  `subtree_check` or `no_subtree_check`, and `crossmnt`.
- Client options: `vers=4.2`, `sec=sys`, `hard`, `soft`, `timeo`, `retrans`,
  `rsize`, `wsize`, `noatime`, `_netdev`.
- Prefer hard mounts for data correctness; soft mounts can surface partial I/O
  failures to applications.

## POSIX Extended Attributes

- Namespaces: `user.*`, `security.*`, `system.*`, `trusted.*`.
- Tools: `getfattr -d -m '' file`, `setfattr -n user.key -v value file`,
  `getcap`, `setcap`.
- APIs: `getxattr(2)`, `setxattr(2)`, `listxattr(2)`, `removexattr(2)`.
- Check for `ENOTSUP` and `ERANGE`.
- Preserve with `cp -a`, `rsync -X`, `tar --xattrs`.

## Atomic File Writes

- Write temp file in the target directory, write content, `fsync`, close,
  rename over target.
- `O_TMPFILE` is preferable where supported.
- For directory-entry durability, `fsync` the parent directory after rename
  when correctness across power loss matters.

## Path Traversal And Trust

- Avoid broad recursive walks over untrusted roots. They can hang on FUSE,
  automounts, network filesystems, device trees, cyclic bind mounts, or hostile
  symlink layouts.
- Constrain traversal with explicit roots, depth limits, mount-boundary policy,
  symlink policy, file type filters, and timeouts or cancellation.
- Prefer direct path validation over search when the caller already supplied a
  concrete path. If search is required, search only known directories and stop
  at the first validated candidate.
- For paths later used at a security boundary, validate the resolved object and
  keep using that resolved path or file descriptor.

## Related Concepts

- Mount namespaces: per-process mount tables. Use `unshare -m`, `nsenter`.
- Bind mounts: `mount --bind /src /dst`; understand propagation flags.
- Loop devices: `losetup -f --show image.raw`.
- dm-crypt/LUKS: block encryption under the filesystem.
- fscrypt: file-level encryption for supported filesystems.
- Quotas: ext4/xfs user, group, project quotas; btrfs qgroups.
