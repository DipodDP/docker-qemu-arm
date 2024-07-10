# docker-qemu-arm

https://gist.github.com/assets/1340674/292c04e2-ca4e-4dca-bfa8-abdada9e175b

Run Docker x86_64 on Arm computers or Android

Original idea: <https://gist.github.com/oofnikj/e79aef095cd08756f7f26ed244355d62> and <https://github.com/egandro/docker-qemu-arm>

This is a automatic installation script. As memory is always short, we also install zram.

## Note (antonyz89)

This repo works a little bit different than the others, I removed all "wget" from scripts and use "git clone" instead because it is more simple.

👉 My porpose is use it with proot-distro and arch linux  on my Samsung Tab S9 Ultra, but can works with other distros too (and without proot-distro).

If you want run with "wget" I suggest you to use the original solution [egandro/docker-qemu-arm](https://github.com/egandro/docker-qemu-arm).
Just remember to update the alpine-virt version to the latest and use my [answerfile](./answerfile) to work properly with the newest alpine-virt versions.

(The old version works fine too, but you can't use docker compose because it's not included on repository of Alpine 3.14)


## Android Phone/Tablet with Termux

⚠️ Using **proot-distro**? Uncomment `export PREFIX` line on `config.env`
⚠️ Using **proot-distro** with **ubuntu**? Use `./ubuntu-setup.sh` instead of `./termux-setup.sh`

```bash
$ git clone https://github.com/antonyz89/docker-qemu-arm
$ cd docker-qemu-arm
$ ./termux-setup.sh
```


## Raspberry Pi OS

```bash
$ git clone https://github.com/antonyz89/docker-qemu-arm
$ cd docker-qemu-arm
$ ./pi-setup.sh
```

## Fedora ARM

```bash
$ git clone https://github.com/antonyz89/docker-qemu-arm
$ cd docker-qemu-arm
$ ./fedora-arm-setup.sh
```


## Postinstall & fun

- enter on folder called "alpine"
- adjust port forwarding to the VM in "startqemu.sh" (add something like `,hostfwd=tcp::5432-:5432` to the list in `-netdev`)
- start the VM with "startqemu.sh"
    - root passwort is "Secret123" but root in ssh is locked by password
    - please change the password anyway
- you can ssh to the VM with a 2nd Terminal and "ssh2qemu.sh" qemukey / qemukey.ssh are SSH keys
- run a "uname -a" and a "docker run hello-world"
- now you can move (and rename) "alpine" folder and delete the `qemu-arm-arm` folder :D

## Using docker outside of qemu

Want use docker in your terminal without need enter on qemu machine? like:

```sh
# your terminal
cd your/project
docker compose up -d
# ...
```

Just follow these steps:

1. Download docker static binary
    - ⚠️ or just **install docker directly** (e.g. `sudo pacman -S docker`)
    1. https://download.docker.com/linux/static/stable/aarch64/
    2. e.g.: `wget https://download.docker.com/linux/static/stable/aarch64/docker-24.0.7.tgz`

    - Extract it
        1. `tar -xvf docker-24.0.7.tgz`
        2. `cd docker-24.0.7`
        3. `sudo cp docker /usr/local/bin/`

2. Add to your .bashrc/.zshrc/etc file:
    - ```sh
        eval $(ssh-agent)
        # Change `~/docker-qemu-arm/alpine/` to your actual folder
        ssh-add ~/docker-qemu-arm/alpine/qemukey 
        export DOCKER_HOST=ssh://root@localhost:2222

        # Change `~/docker-qemu-arm/alpine/` to your actual folder
        alias stq="cd ~/docker-qemu-arm/alpine && ./startqemu.sh && cd"
        alias sshq="cd ~/docker-qemu-arm/alpine && ./ssh2qemu.sh && cd"
        ```

    - **Using fish shell?** use it instead:

        ```sh
        if test -z (pgrep ssh-agent | string collect)
            eval (ssh-agent -c)
            set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
            set -Ux SSH_AGENT_PID $SSH_AGENT_PID
            ssh-add /path/to/qemukey # e.g. ssh-add ~/alpine/qemukey
        end

        export DOCKER_HOST=ssh://root@localhost:2222
        ```

3. Save, open a new terminal and now run:

    ```sh
    docker ps
    # result
    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
    ```

    If don't work, have sure that you have started qemu with `startqemu.sh`

4. 🚀 It's done!

**Obs:** you can use docker outside of qemu, but yours containers will be running inside qemu.

**Obs 2:** need use docker compose? You can install it with `sudo pacman -S docker-compose` or equivalent

## Known issues

- kubernetes (which is a very stupid idea): cgroups in Alpine must be configured properly
- just in case you really want that here is how: <https://wiki.alpinelinux.org/wiki/Docker>

## Thanks

- Thanks to everybody who made this happen.

## Changelog
### 2021/10/07

- added config.env - this makes it much simpler for developers to tweak version numbers
- fixed issue with alpine for zram
- updated to alpine-virt-3.14.0-x86_64.iso

### 2023/01/18 (antonyz89)

- updated README with steps to use docker outside of qemu (via ssh)
- updated to alpine-virt-3.19.0-aarch64.iso
- updated answerfile to works with 3.19.0
- using local files instead download all files with wget. Clone the repo, execute the script and delete the repo is more simple


