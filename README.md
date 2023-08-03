# play-remote-wavs

## Usage

```
[/path/to/wav]
[/path/to/wav] [transcript]
[/path/to/wav] [start] [duration]
[/path/to/wav] [start] [duration] [transcript]
```

``` bash
$ ssh username@192.168.1.3
$ chmod 700 ~/.ssh
$ chmod 600 ~/.ssh/authorized_keys
```

### Windows

管理员身份打开 powershell

``` bash
$ Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
$ ssh-keygen
$ type $env:USERPROFILE\.ssh\id_rsa.pub | ssh username@192.168.1.3 "cat >> .ssh/authorized_keys"
```

``` bash
$ .\play.ps1 --help
Usage: .\play.ps1 [user@]host:<wav_list> [start_index]

$ .\play.ps1 username@192.168.1.3:/path/to/wav.lst 23
```

### Linux & MacOS

``` bash
$ ssh-keygen
$ ssh-copy-id -i ~/.ssh/id_rsa.pub username@192.168.1.3
```

``` bash
$ bash play.sh username@192.168.1.3:/path/to/wav.lst 23
```
