# replay.fish

> Run Bash commands replaying changes in [Fish](https://fishshell.com). 🍤

Let's say you need to run a Bash command, and want Fish to inherit changes in the environment, e.g., exported and unset variables, changes to the `$PATH`, and so on. How do you do that?

```console
$ exec bash -c "$commands; exec fish"
```

Caveats? Unfortunately, yes.

There's no way to preserve the last command exit status. You'll lose the entire state of your session; history may not sync up correctly if you have Fish running in other terminal tabs, local variables are gone. Fish takes a little while to start up. Moreover, things Fish is configured to do on startup like running configuration snippets or displaying a custom greeting may not be appreciated. If jobs are running in the background, they'll be terminated too.

Replay runs your commands in Bash, captures exported variables, aliases, `$PWD` changes, and reproduces them in Fish so you don't have to `exec`-away your session.

## Installation

Install with [Fisher](https://github.com/jorgebucaran/fisher):

```console
fisher install jorgebucaran/replay.fish
```

## Quickstart

This sets the environment variable `PYTHON` in your session.

```console
$ replay export PYTHON=python2
$ echo $PYTHON
python2
```

This will download and install the latest Node release (requires [`nvm`](https://github.com/nvm-sh/nvm)).

```console
$ replay "source ~/.nvm/nvm.sh --no-use && nvm use latest"
```

Bash aliases? You got it.

```console
$ replay alias g=git
$ g init
Initialized empty Git repository in /home/users/jb/code/replay.fish/.git/
```

Replay will even take care of special variables like `$PWD`, switching directories if needed.

```console
$ pwd
/home/users/jb/replay.fish
$ replay cd ~
$ pwd
/home/users/jb
```

> Replay is not bulletproof! Interactive utilities, such as [`ssh-add`](http://man7.org/linux/man-pages/man1/ssh-add.1.html) are not currently supported.

## License

[MIT](LICENSE.md)
