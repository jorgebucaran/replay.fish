# replay.fish

> Run Bash commands replaying changes in Fish. 🍤

Replay is a POSIX-compatible shell execution wrapper for [Fish](https://fishshell.com). Let's say you need to source a Bash script, but want to preserve changes in Fish, e.g., changes to the `$PATH`, exported variables, and so on. How do you that?

```console
$ exec bash -c "$commands; exec fish"
```

Fork a POSIX-compatible shell, run your scripts there, inherit the environment in Fish. Any caveats? Yes.

There's no way to preserve the last command exit status. You'll lose the entire state of your session; history may not sync up correctly if you have Fish running in other terminal tabs, local variables are gone. Fish takes a little while to start up. Moreover, things Fish is configured to do on startup like running configuration snippets or displaying a custom greeting, may not be appreciated. If jobs are running in the background, they'll be terminated too.

Replay runs your commands in Bash, captures environment changes, and reproduces them in Fish so you don't have to [`exec`](https://fishshell.com/docs/current/commands.html#exec)-away your session. Now you can have your 🍥 and eat it.

## Installation

Install with [Fisher](https://github.com/jorgebucaran/fisher):

```console
fisher install jorgebucaran/replay.fish
```

## Usage

```console
$ replay export PYTHON=python2
```

This will set the environment variable `PYTHON` in your session.

```console
$ echo $PYTHON
python2
```

Use quotes to evaluate multiple commands. Here's how you can download the latest Node release via [nvm-sh](https://github.com/nvm-sh/nvm).

```console
$ replay "source ~/.nvm/nvm.sh --no-use && nvm use latest"
```

Changing the current directory in a subshell leaves you back where you were when you exit. Replay switches directories instead. To move backward through the directory history use [`cd -`](https://fishshell.com/docs/current/commands.html#cd) or [`prevd`](https://fishshell.com/docs/current/commands.html#prevd) as you usually would.

```console
$ pwd
/home/users/jb/replay.fish
$ replay cd ~
$ pwd
/home/users/jb
```

Replay supports Bash aliases out of the box.

```console
$ replay alias g=git
$ g init
Initialized empty Git repository in /home/users/jb/code/replay.fish/.git/
```

Replay is not infallible. Interactive utilities, such as [`ssh-add`](http://man7.org/linux/man-pages/man1/ssh-add.1.html) are not currently supported.

## License

[MIT](LICENSE.md)
