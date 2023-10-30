# Xahaud Docker Container

Docker container to run a Xahau node on MAINNET.

## Live build:

`2023.10.30-release+443` - https://build.xahau.tech/2023.10.30-release%2B443

## IPv6 edition (!)

For Docker + IPv6 setup, see:

- https://gist.github.com/WietseWind/846b6274c0e7208e3b8fa96fb1149c07#file-docker-ipv6-install-sh

### ⚠️ Warning regarding the pinned binary

All Xahau builds are available at https://build.xahau.tech. 

**The build script in this repository contains the right pinned build.**

If you build the image yourself, without the build script, you will have to manually replace the right build version! If you don't, the binary will fail to sync and most likely crash during the sync process.

---

## XAHAU MAINNET, NETWORK ID 21337

```
                   $$\                                 $$\ 
                   $$ |                                $$ |
$$\   $$\ $$$$$$\  $$$$$$$\   $$$$$$\  $$\   $$\  $$$$$$$ |
\$$\ $$  |\____$$\ $$  __$$\  \____$$\ $$ |  $$ |$$  __$$ |
 \$$$$  / $$$$$$$ |$$ |  $$ | $$$$$$$ |$$ |  $$ |$$ /  $$ |
 $$  $$< $$  __$$ |$$ |  $$ |$$  __$$ |$$ |  $$ |$$ |  $$ |
$$  /\$$\\$$$$$$$ |$$ |  $$ |\$$$$$$$ |\$$$$$$  |\$$$$$$$ |
\__/  \__|\_______|\__|  \__| \_______| \______/  \_______|
```

### Build:

WARNING!

- This will remove any existing image with the same `xahaud` release tag
- The container tag will `xahaud-mainnet`

```bash
./build
```

### Run:

WARNING! This will remove any running container called `xahaud-mainnet`!

```bash
./up
```

### Config & database

Config and database perist in `./store/etc` and `./store/db`. Logfiles in `./store/log`.

Feel free to clean the `db` and `log` folder at your convenience, contents will be re-created.

### Xahaud server identity

The `xahaud` server identity will perist as long as you keep the contents of `wallet.db`
in the `./store/db` folder.

You can stop, remove & re-create the container: as long as this file persists your server
identity will be the same after a restart.

### Remote access

This container runs `ssh` as well. You can SSH into the container, but for every build the
SSH server identity will change. The user is `root`, so: `ssh root@localhost -p 2222`.

To allow SSH access (key only), add your pubkey(s) to `./store/ssh/authorized_keys`

NOTE: not a hidden file, don't start with a dot). Make sure to `chmod 400` the file.
Make sure the file is owned by `root` (chown root:root).

### Commands

To get the latest server status (or run another `xahaud` command):

```bash
# docker exec {container} {binary} {cliopts}
docker exec xahaud-mainnet xahaud server_info
```

To check the current sync status:

```bash
# docker exec {container} {binary} {cliargs} {cliopts} | grep {string to match}
docker exec xahaud-mainnet xahaud -q server_info | grep complete_ledgers
```

To check the peer connections:

```bash
# docker exec {container} {binary} {cliargs} {cliopts} | grep {string to match}
docker exec xahaud-mainnet xahaud -q peers|grep address
```

To check the live Xahaud logs:

```bash
# docker exec {container} {binary} {cliargs} {cliopts} | grep {string to match}
docker exec xahaud-mainnet tail -f /opt/xahaud/log/debug.log
```

To monitor sync status (exit with `CTRL-C`):
```bash
watch 'docker exec xahaud-mainnet xahaud -q server_info | grep complete_ledgers'
```

To start/stop/restart `xahaud`:

```bash
systemctl start xahaud
systemctl restart xahaud
systemctl stop xahaud
```

To prevent `xahaud` from auto-starting when the container starts:

```bash
systemctl disable xahaud
```

---

Enjoy!
