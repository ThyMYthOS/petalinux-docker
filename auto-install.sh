#!/usr/bin/env expect
set timeout -1
set install_dir [lindex $argv 0]

spawn ./petalinux-v2015.2.1-final-installer.run $install_dir
expect "Press Enter to display the license agreements"
send "\r"
# petalinux-v2015.2.1-final/etc/license/Petalinux_EULA.txt  (press RETURN)
# Do you accept Xilinx End User License Agreement? [y/N] >
expect "*(press RETURN)*"
send "\rqy\r"
# petalinux-v2015.2.1-final/etc/license/WebTalk_notice.txt  (press RETURN)
# Do you accept Webtalk Terms and Conditions? [y/N] >
expect "*(press RETURN)*"
send "\rqy\r"
# petalinux-v2015.2.1-final/etc/license/Third_Party_Software_End_User_License_Agreement.txt" may be a binary file.  See it anyway?
# Do you accept Third Party End User License Agreement? [y/N] >
expect "*See it anyway?*"
send "ny\r"
expect eof
