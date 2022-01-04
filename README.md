<div align="center">
    <h1>instantTOOLS</h1>
    <p>Development tools for instantOS</p>
    <img width="300" height="300" src="https://raw.githubusercontent.com/instantOS/instantLOGO/main/png/tools.png">
</div>


## Installation

```sh
curl -s https://raw.githubusercontent.com/instantOS/instantTOOLS/main/netinstall.sh | bash
```

--------  


build a single instantos package for the repo

```sh
ibuild singlebuild
```

release a new stable branch version

```sh
ibuild release
```

back up repo to other git servers in case github goes boom

```sh
ibuild backup
```

clear and rebuild the pacman repo

```sh
ibuild rebuild
```

update aur package in the repo

```sh
ibuild aurupdate
```

clone github stuff

```sh
ibuild clone
```

get a copy of the pacman repo

```sh
ibuild download
```

build and install a single instantOS package

```sh
ibuild install
```

install a single aur package

```sh
ibuild aur
```

build a full copy of the pacman repo

```sh
ibuild fullrepo
```

upload files to pacman repo

```sh
ibuild push
```

## Future feature ideas

- rework some utils with ansible
- add web3 repo storage upload util



