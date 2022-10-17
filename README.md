# rp -- Remote Project
## synchronize a local development tree to a remote server.

rp synchronizes your local source tree to a remote server continuosly, so you can edit locally on a slow, low-powered machine, but then build and test on a remote, much faster machine.

**rp currently only works in git repositories**

## Installation
It is just a shell script, so copy it somewhere on your path.

You will find it completely unusable unless you setup ssh for key-based login.

You will find it annoyingly slow unless you setup ssh ControlMaster so connections are reused.

## Use
```
$ cd projects/myproject

$ rp --init remotemachine.example.net
$ #rp --init is only needed once per repo.

$ #hack hack hackity hack

$ rp make all
  <build output>

$ rp make test
  <test output>
```

Running remote commands via rp works in any subdirectory of your repo, and will run the command in the corresponding subdirectory on the remote host.

If the remote repo is not at the same absolute path as the local repo, you can specify remotemachine.example.net:/path/to/remote/repo when running ``rp --init``.

Running a command waits for any in progress file synchronization to complete.

The synchronization daemon that is automatically started in the background will timeout after long periods of inactivity, but will be automatically restarted when you next run a command.
