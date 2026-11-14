#!/usr/bin/env bash
GENERATED_AT=$(date)
UPTIME_TEXT=$(uptime -p)
DISK_USAGE=$(df -P / | awk 'NR == 2 {print $5}')
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')
check_disk_status() {
	local percent="${1%\%}"

	if((percent >= 80 )); then 
		echo "WARNING"
	else 
		echo "OK"
	fi

}
DISK_STATUS=$(check_disk_status "$DISK_USAGE")
echo "$GENERATED_AT"
echo "$UPTIME_TEXT"
echo "$DISK_USAGE"
echo "$MEM_TOTAL MiB"
echo "$MEM_AVAILABLE MiB"
echo "$DISK_STATUS"

cat > /var/www/html/viikko3/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Linux Week 3 - Server Status</title>
</head>
<style>
    body {
        background: #101827;
        color: #f8fafc;
        font-family: Arial, sans-serif;
        max-width: 850px;
        margin: 40px auto;
        padding: 20px;
        line-height: 1.7;
    }

    h1, h2, h3 {
        color: #60a5fa;
    }
.status-box {
    background: #1c2b44;
    border: 1px solid #334155;
    border-radius: 12px;
    padding: 15px 25px;
    margin: 12px 0;
}
</style>
<body>
    <h1>My Linux Server Status</h1>

    <div class="status-box"><p>Report generated: $GENERATED_AT</p></div>
    <div class="status-box"><p>Server uptime: $UPTIME_TEXT</p></div>
    <div class="status-box"><p>Disk usage: $DISK_USAGE</p></div>
    <div class="status-box"><p>Disk status: $DISK_STATUS</p></div>
    <div class="status-box"><p>Total RAM: $MEM_TOTAL MiB</p></div>
    <div class="status-box"><p>Available RAM: $MEM_AVAILABLE MiB</p></div>
<div class="status-box">	
<h2>Commands used</h2>

<ul>
    <li>date - Shows the current date, time and timezone.</li>
    <li>uptime -p - Shows how long the server has been running.</li>
    <li>free -m - Displays RAM information in MiB.</li>
    <li>
        df -P / | awk 'NR == 2 {print &#36;5}'
        - Extracts the root filesystem disk usage percentage.
    </li>
</ul>
</div>
<div class="status-box">
<h2>How does the script work?</h2>

<p>
    The Bash script collects server information using
    Linux commands and stores the results in variables.
    It generates an HTML report using the collected data.
</p>

<p>
    A function checks the disk usage percentage.
    If usage is 80% or higher, the status is WARNING.
    Otherwise, the status is OK.
</p>
</div>
<div class="status-box">
<h2>Automatic updates</h2>

<p>
    Cron runs the Bash script once every minute.
    The generated HTML report is updated automatically.
    The schedule continues working after a server reboot.
</p>
</div>
<div class="status-box">
<h2>Test results</h2>

<p>
    The Bash syntax check passed, and the script
    generated the HTML report successfully.
</p>
</div>
<div class="status-box">
<h3>Disk status tests</h3>
<ul>
    <li>50% - OK</li>
    <li>80% - WARNING</li>
    <li>90% - WARNING</li>
</ul>
</div>
<div class="status-box">
<h3>Automatic updates and reboot</h3>
<p>
    The report updated automatically using cron.
    After rebooting the virtual machine, the website
    was accessible and automatic updates continued.
    The Week 2 application was also working.
</p>
</div>
<div class="status-box">
<h2>What I learned</h2>

<p>
    I had a problem with the awk command because
    I typed one character incorrectly.
    After correcting it, the script worked.
    I learned how important correct syntax is in Bash.
</p>
</div>
</body>
</html>
EOF
