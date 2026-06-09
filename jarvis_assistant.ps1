<#
  J.A.R.V.I.S - Desktop AI Assistant
  Full voice control for your Windows laptop
  Saves itself to Startup automatically
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Speech

# ══ CONFIG ═══════════════════════════════════════════════════
$script:listening = $true
$script:synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
$script:synthesizer.Rate = -1
$script:synthesizer.Volume = 100

# ══ UI ═══════════════════════════════════════════════════════
$form = New-Object System.Windows.Forms.Form
$form.Text = "J.A.R.V.I.S"
$form.Size = New-Object System.Drawing.Size(500, 420)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(10, 14, 26)
$form.ForeColor = [System.Drawing.Color]::White
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.TopMost = $true
$form.Add_Shown({$form.Activate(); $script:synthesizer.SpeakAsync("Hello sir, JARVIS online. How can I help you?")})

# Title
$title = New-Object System.Windows.Forms.Label
$title.Text = "◆ J.A.R.V.I.S"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::FromArgb(0, 170, 255)
$title.Size = New-Object System.Drawing.Size(460, 50)
$title.Location = New-Object System.Drawing.Point(20, 20)
$title.TextAlign = "MiddleLeft"
$form.Controls.Add($title)

# Status
$status = New-Object System.Windows.Forms.Label
$status.Text = "● Listening..."
$status.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$status.ForeColor = [System.Drawing.Color]::FromArgb(68, 221, 255)
$status.Size = New-Object System.Drawing.Size(460, 24)
$status.Location = New-Object System.Drawing.Point(24, 72)
$form.Controls.Add($status)

# Transcript label
$transLabel = New-Object System.Windows.Forms.Label
$transLabel.Text = "YOU SAID:"
$transLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
$transLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 255, 255, 40)
$transLabel.Size = New-Object System.Drawing.Size(460, 14)
$transLabel.Location = New-Object System.Drawing.Point(24, 110)
$form.Controls.Add($transLabel)

# Transcript box
$transBox = New-Object System.Windows.Forms.TextBox
$transBox.Multiline = $false
$transBox.ReadOnly = $true
$transBox.BackColor = [System.Drawing.Color]::FromArgb(15, 20, 35)
$transBox.ForeColor = [System.Drawing.Color]::FromArgb(255, 255, 255, 180)
$transBox.Font = New-Object System.Drawing.Font("Segoe UI", 13)
$transBox.BorderStyle = "None"
$transBox.Size = New-Object System.Drawing.Size(460, 30)
$transBox.Location = New-Object System.Drawing.Point(24, 128)
$form.Controls.Add($transBox)

# Separator
$sep = New-Object System.Windows.Forms.Label
$sep.Text = ""
$sep.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 255, 10)
$sep.Size = New-Object System.Drawing.Size(460, 1)
$sep.Location = New-Object System.Drawing.Point(20, 168)
$form.Controls.Add($sep)

# Response label
$respLabel = New-Object System.Windows.Forms.Label
$respLabel.Text = "JARVIS:"
$respLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
$respLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 255, 255, 40)
$respLabel.Size = New-Object System.Drawing.Size(460, 14)
$respLabel.Location = New-Object System.Drawing.Point(24, 180)
$form.Controls.Add($respLabel)

# Response box
$respBox = New-Object System.Windows.Forms.TextBox
$respBox.Multiline = $true
$respBox.ReadOnly = $true
$respBox.ScrollBars = "Vertical"
$respBox.BackColor = [System.Drawing.Color]::FromArgb(15, 20, 35)
$respBox.ForeColor = [System.Drawing.Color]::FromArgb(255, 255, 255, 130)
$respBox.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$respBox.BorderStyle = "None"
$respBox.Size = New-Object System.Drawing.Size(460, 120)
$respBox.Location = New-Object System.Drawing.Point(24, 198)
$form.Controls.Add($respBox)

# Command log
$logLabel = New-Object System.Windows.Forms.Label
$logLabel.Text = "RECENT:"
$logLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
$logLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 255, 255, 30)
$logLabel.Size = New-Object System.Drawing.Size(460, 14)
$logLabel.Location = New-Object System.Drawing.Point(24, 330)
$form.Controls.Add($logLabel)

$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ReadOnly = $true
$logBox.ScrollBars = "Vertical"
$logBox.BackColor = [System.Drawing.Color]::FromArgb(10, 14, 26)
$logBox.ForeColor = [System.Drawing.Color]::FromArgb(255, 255, 255, 40)
$logBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$logBox.BorderStyle = "None"
$logBox.Size = New-Object System.Drawing.Size(460, 40)
$logBox.Location = New-Object System.Drawing.Point(24, 348)
$form.Controls.Add($logBox)

# ══ SPEECH RECOGNITION ═══════════════════════════════════════
$engine = New-Object System.Speech.Recognition.SpeechRecognitionEngine
$engine.SetInputToDefaultAudioDevice()

# Command grammar
$cmdChoices = New-Object System.Speech.Recognition.Choices
$cmdChoices.Add(@(
  "hello", "hey jarvis", "hi", "good morning", "good evening",
  "what time is it", "whats the time", "what's the date",
  "who are you", "what can you do",
  "thank you", "thanks", "goodbye", "bye",
  "shutdown", "restart", "sleep", "lock",
  "volume up", "volume down", "mute", "unmute",
  "joke", "tell me a joke", "funny",
  "open browser", "open notepad", "open calculator",
  "open settings", "open task manager",
  "show desktop", "minimize all",
  "screenshot", "take a screenshot",
  "empty recycle bin", "clear clipboard",
  "start listening", "stop listening",
  "help", "what commands"
))
$cmdGrammar = New-Object System.Speech.Recognition.Grammar((New-Object System.Speech.Recognition.GrammarBuilder($cmdChoices)))
$engine.LoadGrammar($cmdGrammar)

# Wildcard grammar for "open *", "search for *", "launch *"
$openGb = New-Object System.Speech.Recognition.GrammarBuilder
$openGb.Append("open")
$openGb.AppendWildcard()
$openGrammar = New-Object System.Speech.Recognition.Grammar($openGb)
$engine.LoadGrammar($openGrammar)

$launchGb = New-Object System.Speech.Recognition.GrammarBuilder
$launchGb.Append("launch")
$launchGb.AppendWildcard()
$launchGrammar = New-Object System.Speech.Recognition.Grammar($launchGb)
$engine.LoadGrammar($launchGrammar)

$searchGb = New-Object System.Speech.Recognition.GrammarBuilder
$searchGb.Append("search for")
$searchGb.AppendWildcard()
$searchGrammar = New-Object System.Speech.Recognition.Grammar($searchGb)
$engine.LoadGrammar($searchGrammar)

$openFileGb = New-Object System.Speech.Recognition.GrammarBuilder
$openFileGb.Append("open file")
$openFileGb.AppendWildcard()
$openFileGrammar = New-Object System.Speech.Recognition.Grammar($openFileGb)
$engine.LoadGrammar($openFileGrammar)

# ══ FUNCTIONS ════════════════════════════════════════════════
function Speak($text) {
  $form.Invoke([Action]{$respBox.Text = $text})
  $script:synthesizer.SpeakAsync($text)
  $form.Invoke([Action]{
    $logBox.Text = "$([DateTime]::Now.ToString('HH:mm')) JARVIS > $text`r`n$($logBox.Text)"
    if ($logBox.Text.Length -gt 2000) { $logBox.Text = $logBox.Text.Substring(0, 2000) }
  })
}

function SetStatus($text, $color) {
  $form.Invoke([Action]{
    $status.Text = $text
    $status.ForeColor = [System.Drawing.Color]::FromArgb($color)
  })
}

function LogCommand($text) {
  $form.Invoke([Action]{
    $logBox.Text = "$([DateTime]::Now.ToString('HH:mm')) You > $text`r`n$($logBox.Text)"
    if ($logBox.Text.Length -gt 2000) { $logBox.Text = $logBox.Text.Substring(0, 2000) }
  })
}

function ProcessCommand($text) {
  $lower = $text.ToLower().Trim()
  $form.Invoke([Action]{$transBox.Text = $text})
  LogCommand($text)
  SetStatus "● Processing..." 0x8844FF
  
  # Greetings
  if ($lower -match "^(hello|hey|hi|good morning|good evening)") {
    $h = (Get-Date).Hour
    $greeting = if ($h -lt 12) {"morning"} elseif ($h -lt 18) {"afternoon"} else {"evening"}
    Speak "Good $greeting, sir. What can I do for you?"
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Time
  if ($lower -match "time") {
    $t = Get-Date -Format "h:mm tt"
    Speak "It's $t."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Date
  if ($lower -match "date") {
    $d = Get-Date -Format "dddd, MMMM d"
    Speak "Today is $d."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Who are you
  if ($lower -match "who are you|what can you") {
    Speak "I am JARVIS, your desktop AI assistant. I can open applications, search the web, control system settings, tell jokes, and more. Try saying open, search for, or help."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Thank you
  if ($lower -match "thank|thanks") {
    Speak "You're welcome, sir."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Goodbye
  if ($lower -match "goodbye|bye") {
    Speak "Goodbye, sir. I'll be here."
    SetStatus "● Sleeping..." 0x666666
    return
  }
  
  # Shutdown / Restart / Sleep / Lock
  if ($lower -match "shutdown") { Speak "Shutting down."; Start-Sleep 1; Stop-Computer -Force; return }
  if ($lower -match "restart") { Speak "Restarting."; Start-Sleep 1; Restart-Computer -Force; return }
  if ($lower -match "sleep") { Speak "Going to sleep."; Start-Sleep 1; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Application]::SetSuspendState("Suspend", $false, $false); return }
  if ($lower -match "lock") { Speak "Locking."; Start-Sleep 0.5; rundll32.exe user32.dll,LockWorkStation; SetStatus "● Listening..." 0x44DDFF; return }
  
  # Volume
  if ($lower -match "volume up") {
    for ($i=0; $i -lt 5; $i++) { $null = [System.Runtime.InteropServices.Marshal]::GetActiveObject("WScript.Shell").SendKeys([char]175) }
    Speak "Volume up."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  if ($lower -match "volume down") {
    for ($i=0; $i -lt 5; $i++) { $null = [System.Runtime.InteropServices.Marshal]::GetActiveObject("WScript.Shell").SendKeys([char]174) }
    Speak "Volume down."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  if ($lower -match "mute") { $null = [System.Runtime.InteropServices.Marshal]::GetActiveObject("WScript.Shell").SendKeys([char]173); Speak "Muted."; SetStatus "● Listening..." 0x44DDFF; return }
  if ($lower -match "unmute") { $null = [System.Runtime.InteropServices.Marshal]::GetActiveObject("WScript.Shell").SendKeys([char]173); Speak "Unmuted."; SetStatus "● Listening..." 0x44DDFF; return }
  
  # Joke
  if ($lower -match "joke") {
    $jokes = @(
      "Why did the scarecrow win an award? Because he was outstanding in his field!",
      "Why don't scientists trust atoms? Because they make up everything!",
      "What do you call a fake noodle? An impasta!",
      "Why did the math book look so sad? Because it had too many problems.",
      "What do you call a bear with no teeth? A gummy bear."
    )
    Speak ($jokes | Get-Random)
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Open specific apps
  if ($lower -match "open browser|open chrome|open edge") {
    Start-Process "https://www.google.com"
    Speak "Opening browser."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  if ($lower -match "open notepad") { notepad; Speak "Opening Notepad."; SetStatus "● Listening..." 0x44DDFF; return }
  if ($lower -match "open calculator") { calc; Speak "Opening Calculator."; SetStatus "● Listening..." 0x44DDFF; return }
  if ($lower -match "open settings") { Start-Process ms-settings:; Speak "Opening Settings."; SetStatus "● Listening..." 0x44DDFF; return }
  if ($lower -match "open task manager") { taskmgr; Speak "Opening Task Manager."; SetStatus "● Listening..." 0x44DDFF; return }
  if ($lower -match "show desktop|minimize") {
    $shell = New-Object -ComObject "Shell.Application"
    $shell.MinimizeAll()
    Speak "Showing desktop."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Screenshot
  if ($lower -match "screenshot") {
    Add-Type -AssemblyName System.Windows.Forms
    $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bmp = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    $gfx.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
    $desktop = [Environment]::GetFolderPath("Desktop")
    $path = "$desktop\Screenshot $((Get-Date).ToString('yyyy-MM-dd HH-mm-ss')).png"
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $gfx.Dispose(); $bmp.Dispose()
    Speak "Screenshot saved to desktop."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Empty recycle bin
  if ($lower -match "empty recycle") {
    $shell = New-Object -ComObject "Shell.Application"
    $rec = $shell.NameSpace(10)
    $rec.Items() | ForEach-Object { $_.InvokeVerb("delete") }
    Speak "Recycle bin emptied."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Clear clipboard
  if ($lower -match "clear clipboard") {
    Set-Clipboard $null
    Speak "Clipboard cleared."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Stop/start listening
  if ($lower -match "stop listening") { $script:listening = $false; Speak "Paused."; SetStatus "● Paused" 0xFF4444; return }
  if ($lower -match "start listening|resume") { $script:listening = $true; Speak "Listening."; SetStatus "● Listening..." 0x44DDFF; return }
  
  # Help
  if ($lower -match "help|what commands") {
    Speak "I respond to: hello, time, date, open [app], launch [app], search for [query], shutdown, restart, sleep, lock, volume up or down, mute, unmute, screenshot, joke, empty recycle bin, clear clipboard, show desktop, who are you, and more."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Wildcard: open * (catch-all)
  if ($lower -match "^open (.+)$") {
    $app = $matches[1].Trim()
    try { Start-Process $app; Speak "Opening $app." }
    catch { Speak "I couldn't find $app. Try a different name." }
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Wildcard: launch *
  if ($lower -match "^launch (.+)$") {
    $app = $matches[1].Trim()
    try { Start-Process $app; Speak "Launching $app." }
    catch { Speak "I couldn't launch $app." }
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Wildcard: search for *
  if ($lower -match "^search for (.+)$") {
    $query = $matches[1].Trim()
    Start-Process "https://www.bing.com/search?q=$([Uri]::EscapeDataString($query))"
    Speak "Searching for $query."
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Wildcard: open file *
  if ($lower -match "^open file (.+)$") {
    $path = $matches[1].Trim()
    if (Test-Path $path) { Start-Process $path; Speak "Opening file." }
    else { Speak "File not found at $path." }
    SetStatus "● Listening..." 0x44DDFF; return
  }
  
  # Fallback
  Speak "I'm not sure how to handle that. Try saying help for a list of commands."
  SetStatus "● Listening..." 0x44DDFF
}

# ══ EVENT HANDLER ═══════════════════════════════════════════
$engine.SpeechRecognized.Add({
  param($s, $e)
  if (-not $script:listening) { return }
  $text = $e.Result.Text
  $confidence = $e.Result.Confidence
  if ($confidence -lt 0.4) { return }
  ProcessCommand($text)
})

$engine.RecognizeAsync([System.Speech.Recognition.RecognizeMode]::Multiple)

# ══ AUTO-START ══════════════════════════════════════════════
$startupPath = [Environment]::GetFolderPath("Startup")
$shortcutPath = "$startupPath\JARVIS.lnk"
if (-not (Test-Path $shortcutPath)) {
  try {
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`""
    $shortcut.Description = "J.A.R.V.I.S AI Assistant"
    $shortcut.Save()
    $form.Invoke([Action]{$logBox.Text = "✅ Auto-start added to Windows Startup`r`n$($logBox.Text)"})
  } catch {
    $form.Invoke([Action]{$logBox.Text = "⚠ Auto-start failed: $_`r`n$($logBox.Text)"})
  }
}

# ══ FORM CLOSE ═══════════════════════════════════════════════
$form.Add_FormClosing({
  $script:synthesizer.SpeakAsync("JARVIS shutting down.")
  $engine.RecognizeAsyncCancel()
  $engine.Dispose()
})

# ══ SHOW ════════════════════════════════════════════════════
$form.ShowDialog()
