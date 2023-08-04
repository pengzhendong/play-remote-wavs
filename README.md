# play-remote-wavs

## Usage

``` bash
$ cat wav.lst

http://ip:port/path/to/wav
http://ip:port/path/to/wav [transcript]
http://ip:port/path/to/wav [start] [duration]
http://ip:port/path/to/wav [start] [duration] [transcript]
```

### Windows

以管理员权限打开 powershell

``` bash
$ Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
$ .\play.ps1 http://ip:port/wav.lst [start_id]
```

### Linux & MacOS

``` bash
$ bash play.sh http://ip:port/wav.lst [start_id]
```
