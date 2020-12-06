# replay.fish

> Run Bash commands replaying changes in [Fish](https://fishshell.com). 🍤

Replay is a POSIX-compatible shell execution wrapper for [Fish](https://fishshell.com). Maybe you need to source a Bash script, but want to preserve changes in Fish, e.g., changes to the `$PATH`, exported variables, and so on. How do you do that?

```console
$ exec bash -c "$commands; exec fish"
```

Maybe fork a POSIX-compatible shell, run your scripts there, inherit the environment in Fish. Caveats? Yes.

There's no way to preserve the last command exit status. You'll lose the entire state of your session; history may not sync up correctly if you have Fish running in other terminal tabs, local variables are gone. Fish takes a little while to start up. Moreover, things Fish is configured to do on startup like running configuration snippets or displaying a custom greeting, may not be appreciated. If jobs are running in the background, they'll be terminated too.

Replay runs your commands in Bash, captures exported variables, aliases, $PWD changes, and reproduces them in Fish so you don't have to [`exec`](https://fishshell.com/docs/current/commands.html#exec)-away your session.

## Installation

Install with [Fisher](https://github.com/jorgebucaran/fisher):

```console
fisher install jorgebucaran/replay.fish
```

## Quickstart

This will set the environment variable `PYTHON` in your session.

```console
$ replay export PYTHON=python2
$ echo $PYTHON
python2
```

This will download the latest Node release via [nvm-sh](https://github.com/nvm-sh/nvm).

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

> Replay is not bulletproof yet! Interactive utilities, such as [`ssh-add`](http://man7.org/linux/man-pages/man1/ssh-add.1.html) are not currently supported.

## License

[MIT](LICENSE.md)
