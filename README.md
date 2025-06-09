For ease of use put this file in "C:\"


Go to Task Scheduler


Click Create Task


Name: setNTPatBoot

Description: Sets the time&date from a result of a NTP server (0.dk.pool.ntp.org)

Run with highest privileges ✔️



click Change Users or Group

type "administrator" and check name

if successfull press "OK".. if not, figure out what your administrator account is called and type that



change tab to triggers

click "New..."

change "Begin the task" to "At startup" or "At logon" if you never powerdown your device

click "OK"


change tab to actions

click "New..."

in the "program/script"

type "powershell.exe -ExecutionPolicy Bypass -File "C:\setNTPatBoot.ps1"

A box will appear and should tell you the augments

if so, press Yes. if not then take the "-ExecutionPolicy Bypass -File "C:\setNTPatBoot.ps1" and put it in the "add arguments (optional):" box

Press OK


It should now be setup


If you are not wanting to use the 0.dk.pool.ntp.org server then go into the .ps1 file and change that to match your desires
