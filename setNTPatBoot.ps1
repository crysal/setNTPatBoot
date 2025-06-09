$testResult = try {
    Set-Date -Date (Get-Date).AddMinutes(1) -WhatIf -ErrorAction Stop 2>&1
} catch {
    $_
}
if ($testResult -is [System.Management.Automation.ActionPreferenceStopException] -or
    $testResult.ToString() -match "Access.*denied|not.*authorized|permission") {
    Write-Host "ERROR: You do not have permission to change the system time."
	Start-Sleep -Seconds 2
    exit 1
}
$maxRetries = 3
$success = $false
for ($i = 1; $i -le $maxRetries; $i++) {
    Write-Host "Attempt $i of $maxRetries Querying NTP server..."
    $ntpOutput = w32tm /stripchart /computer:0.dk.pool.ntp.org /dataonly /samples:1

    $currentTimeLine = $ntpOutput | Where-Object { $_ -match "^The current time is" }

    if ($currentTimeLine -match "The current time is (\d{2})/(\d{2})/(\d{4}) (\d{2})\.(\d{2})\.(\d{2})") {
        $day   = $matches[1]
        $month = $matches[2]
        $year  = $matches[3]
        $hour  = $matches[4]
        $min   = $matches[5]
        $sec   = $matches[6]
		
        $correctedDateTime = "$month/$day/$year $hour`:$min`:$sec"
		
        Write-Host "Parsed NTP time: $correctedDateTime"
        Set-Date -Date $correctedDateTime
        $success = $true
        break
    } else {
        Write-Host "Warning: NTP response did not contain valid time. Retrying..."
        Start-Sleep -Seconds 2
    }
}

if (-not $success) {
    Write-Host "ERROR: Failed to retrieve valid time from NTP server after $maxRetries attempts."
	Start-Sleep -Seconds 2
    exit 2
}
