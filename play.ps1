if ($args.Count -lt 2) {
  echo "Usage: .\play.ps1 [user@]host:<wavs_dir> <wavlist> [start_index]"
  exit
}

[string[]]$wavs = Get-Content -Path $args[1]
$i = 0
if ($args[2]) {
  $i = $args[2]
}

while ($i -lt $wavs.length) {
  $wav = $wavs[$i]
  .\pscp.exe -scp $($args[0] + "/" + $wav) .
  .\sox.exe $wav -d
  rm $wav
  echo "=================================================================="
  echo "Played ($($i + 1)/$($wavs.length))): $wav."
  echo "Press [r]eplay [n]ext [p]revious [q]uit"
  echo "=================================================================="
  $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').Character
  if ($key -eq 'q') {
    exit
  } elseif ($key -eq 'n') {
    $i++
    if ($i -ge $wavs.length) {
      $i = $wavs.length - 1
      echo "=======================Reached end of list.======================="
    }
  } elseif ($key -eq 'p') {
    $i--
    if ($i -lt 0) {
      $i = 0
      echo "====================Reached beginning of list.===================="
    }
  } elseif ($key -ne 'r') {
    echo "Unknown key: $key"
    exit
  }
}
