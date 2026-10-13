#!/bin/bash

email_id="sajebk007@gmail.com"
Report="/tmp/system-usage-report.txt"

memory_usage(){
	echo ""
	echo "Checking Memory Usage..........."
	echo ""
	free -h
	echo ""
}

cpu_usage(){
	echo "Checking CPU Usage.............."
	top -bn1 | grep "Cpu(s)"
	echo ""
}

disk_usage(){
	echo ""
	echo "Checking Disk Usage............."
	echo ""
	df -h
	echo ""
	echo "Actual Root Disk Usage"
	df -h | grep '/dev/sda2'

}

running_services(){
	echo "Checking running services........."
	systemctl list-units --type=service --state=running
	echo ""
}


generate_report(){

        echo "Generating System Health Report..."

        {
                echo "=========================================="
                echo "       SYSTEM HEALTH MONITORING REPORT"
                echo "=========================================="
                echo "Date:$(date)"
                echo ""

                echo "========== DISK USAGE =========="
                disk_usage

                echo "========== CPU USAGE =========="
                cpu_usage              

                echo "========== MEMORY USAGE =========="
                memory_usage

                echo "========== RUNNING SERVICES =========="
                running_services

                echo "=========================================="
                echo "Report generated successfully."
                echo "=========================================="

        } | tee "$Report"
        echo "Report saved to: $Report"
}

send_email(){

        echo "Sending report to $email_id..."

        if mail -s "System Health Report" "$email_id" < "$Report"; then
                echo "Report sent successfully: $email_id."
        else
                echo "Failed to send email."
        fi
}
generate_report
send_email
