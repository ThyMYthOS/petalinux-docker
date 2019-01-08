#!/usr/bin/env expect
set timeout -1
set install_dir [lindex $argv 0]

spawn ./petalinux-v2015.2.1-final-installer.run $install_dir
expect "Press Enter to display the license agreements"
send "\r"
# Do you accept Xilinx End User License Agreement? [y/N] >
expect "*>*"
send "y\r"
# Do you accept Webtalk Terms and Conditions? [y/N] >
expect "*>*"
send "y\r"
# Do you accept Third Party End User License Agreement? [y/N] >
expect "*>*"
send "y\r"
expect eof
