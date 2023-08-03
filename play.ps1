if ($args.Count -lt 1) {
  echo "Usage: .\play.ps1 [user@]host:<wav_list> [start_index]"
  exit
}

$i = 0
if ($args[1]) {
  $i = $args[1]
}

$hostname = $args[0] -replace ":(.*)", ""
scp $args[0] wav.lst
[string[]]$wavs = Get-Content -Path wav.lst
while ($i -lt $wavs.length) {
  $wav = "audio.wav"
  if (Test-Path $wav) {
    Remove-Item $wav
  }
  [string[]]$array = $wavs[$i] -Split " "
  scp ${hostname}:$($array[0]) $wav
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
  } elseif ($key -eq 'n') {
    $i++
    if ($i -ge $wavs.length) {
      $i = $wavs.length - 1
      echo "!!!!Reached end of list!!!!"
    }
  } elseif ($key -eq 'p') {
    $i--
    if ($i -lt 0) {
      $i = 0
      echo "!!!!Reached beginning of list!!!!"
    }
  } elseif ($key -ne 'r') {
    echo "Unknown key: $key"
    exit
  }
}
