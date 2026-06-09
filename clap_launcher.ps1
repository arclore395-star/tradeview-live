# Clap Launcher — listens for claps via mic, opens website on detection
# Uses .NET System.Speech (built into Windows, no install needed)

param(
  [string]$Url = "https://arclore395-star.github.io/tradeview-live/",
  [int]$Threshold = 55,       # audio level 0-100. Claps spike near 100.
  [int]$Cooldown = 1500        # ms between clap triggers
)

Add-Type -AssemblyName System.Speech

try {
  $engine = New-Object System.Speech.Recognition.SpeechRecognitionEngine
  $engine.SetInputToDefaultAudioDevice()
  $engine.LoadGrammar((New-Object System.Speech.Recognition.DictationGrammar))
} catch {
  Write-Host "ERROR: Could not initialize speech engine. $_"
  Write-Host "Make sure a microphone is connected and Speech Recognition is enabled."
  pause
  exit 1
}

$script:lastClapTime = 0
$script:clapCount = 0
$script:running = $true

Write-Host ""
Write-Host "  ╔══════════════════════════════════╗"
Write-Host "  ║      J.A.R.V.I.S  LAUNCHER       ║"
Write-Host "  ╠══════════════════════════════════╣"
Write-Host "  ║  Clap to open: $($Url.Substring(0, [Math]::Min(40, $Url.Length)))  ║"
if ($Url.Length -gt 40) { Write-Host "  ║  $($Url.Substring(40))  ║"}
Write-Host "  ╠══════════════════════════════════╣"
Write-Host "  ║  Threshold: $Threshold/100                  ║"
Write-Host "  ║  Cooldown:  $($Cooldown)ms                  ║"
Write-Host "  ╚══════════════════════════════════╝"
Write-Host ""
Write-Host "  👂 Listening for claps..."
Write-Host "  (Close this window to stop)"
Write-Host ""

# Event handler for audio level changes
Register-ObjectEvent -InputObject $engine -EventName AudioLevelUpdated -Action {
  $level = $eventArgs.AudioLevel
  $now = [Environment]::TickCount
  
  if ($level -ge $Threshold -and ($now - $script:lastClapTime) -gt $Cooldown) {
    $script:lastClapTime = $now
    $script:clapCount++
    
    $time = Get-Date -Format "HH:mm:ss"
    Write-Host "  [${time}] 👏 CLAP DETECTED! (level: $level) — Opening site..."
    
    try {
      Start-Process $Url
    } catch {
      Write-Host "  [${time}] ERROR opening URL: $_"
    }
  }
}

# Start listening
$engine.RecognizeAsync([System.Speech.Recognition.RecognizeMode]::Multiple)

# Keep running until user closes
while ($script:running) {
  Start-Sleep -Milliseconds 500
}

Write-Host "Shutting down..."
$engine.RecognizeAsyncCancel()
$engine.Dispose()
