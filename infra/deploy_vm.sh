# Use:
#   expect infra/deploy_vm.sh ubuntu 10.100.0.6 172.18.11.4 master 5672 True A002box
#

set timeout 30

send_user "\n\nStart to login to the test bed...\n\n"

spawn /usr/bin/ssh  [lindex $argv 0]@[lindex $argv 1]
expect "@murano-devbox"

send -- "sudo su\n"
expect "#"

send -- "sed -i \"s/LAB_HOST=''/LAB_HOST='"
send -- [lindex $argv 2]
send -- "'/\" /etc/murano-deployment/lab-binding.rc\n"
expect "#"

send -- "sed -i \"s/RABBITMQ_VHOST='A001box'/RABBITMQ_VHOST='"
send -- [lindex $argv 6]
send -- "'/\" /etc/murano-deployment/lab-binding.rc\n"
expect "#"

send -- "sed -i \"s/RABBITMQ_LOGIN='A001box'/RABBITMQ_LOGIN='"
send -- [lindex $argv 6]
send -- "'/\" /etc/murano-deployment/lab-binding.rc\n"
expect "#"

send -- "sed -i \"s/BRANCH_NAME=''/BRANCH_NAME='"
send -- [lindex $argv 3]
send -- "'/\" /etc/murano-deployment/lab-binding.rc\n"
expect "#"
send -- "rm -rf /opt/git\n"
expect "#"
send -- "mkdir -p /opt/git\n"
expect "#"
send -- "cd /opt/git\n"
expect "#"
send -- "git clone https://github.com/stackforge/murano-deployment -b "
send -- [lindex $argv 3]
send -- "\n"
expect "#"

set timeout 600
send -- "cd murano-deployment/devbox-scripts/\n"
expect "#"
send -- "./murano-git-install.sh prerequisites > 1.log\n"
expect "#"
send -- "./murano-git-install.sh install > 2.log\n"
expect "#"

set timeout 30
send -- "sed -i \"s/connection = sqlite:\\/\\/\\/murano.sqlite/connection = mysql:\\/\\/murano:swordfish@localhost:3306\\/murano/\" /etc/murano-api/murano-api.conf\n"
expect "#"

send -- "sed -i \"s/port = 5672/port = "
send -- [lindex $argv 4]
send -- "/\" /etc/murano-api/murano-api.conf\n"
expect "#"
send -- "sed -i \"s/ssl = False/ssl = "
send -- [lindex $argv 5]
send -- "/\" /etc/murano-api/murano-api.conf\n"
expect "#"

send -- "sed -i \"s/port = 5672/port = "
send -- [lindex $argv 4]
send -- "/\" /etc/murano-conductor/conductor.conf\n"
expect "#"
send -- "sed -i \"s/ssl = False/"
send -- [lindex $argv 5]
send -- "/\" /etc/murano-conductor/conductor.conf\n"
expect "#"

send -- "sed -i \"s/\\\"BootFromVolume\\\": true,//\" /etc/murano-conductor/data/templates/cf/Linux.template\n"
expect "#"
send -- "sed -i \"s/\\\"BootFromVolume\\\": true,//\" /etc/murano-conductor/data/templates/cf/Windows.template\n"
expect "#"

send -- "service murano-api restart\n"
expect "#"
send -- "service murano-conductor restart\n"
expect "#"

send -- "exit\n"
