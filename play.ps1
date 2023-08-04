if ($args.Count -lt 1) {
  echo "Usage: .\play.ps1 http://ip:port/wav.lst [start_id]"
  exit
}

$i = 0
if ($args[1]) {
  $i = $args[1] - 1
}

curl $args[0] -o wav.lst
[string[]]$wavs = Get-Content -Encoding UTF8 -Path wav.lst
while ($i -lt $wavs.length) {
  $wav = "audio.wav"
  if (Test-Path $wav) {
    Remove-Item $wav
  }
  [string[]]$array = $wavs[$i] -Split " "
  curl $($array[0]) -o $wav
  echo "=================================================================="
  echo "($($i + 1)/$($wavs.length)): $($array[0])"
  if ($array.length -eq 1) {
    echo "=================================================================="
    .\sox.exe $wav -d
  } elseif ($array.length -eq 2) {
    echo $($array[1])
    echo "=================================================================="
    .\sox.exe $wav -d
  } elseif ($array.length -eq 3) {
    echo "=================================================================="
    .\sox.exe $wav -d trim $($array[1]) $($array[2])
  } elseif ($array.length -eq 4) {
    echo $($array[3])
    echo "=================================================================="
    .\sox.exe $wav -d trim $($array[1]) $($array[2])
  }
  echo "Press [r]eplay [n]ext [p]revious [q]uit"
  $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').Character
  if ($key -eq 'q') {
    exit
  } elseif ($key -eq 'p') {
    $i--
    if ($i -lt 0) {
      $i = 0
      echo "!!!!Reached beginning of list!!!!"
    }
  } elseif ($key -ne 'r') {
    $i++
    if ($i -ge $wavs.length) {
      $i = $wavs.length - 1
      echo "!!!!Reached end of list!!!!"
    }
  }
}
