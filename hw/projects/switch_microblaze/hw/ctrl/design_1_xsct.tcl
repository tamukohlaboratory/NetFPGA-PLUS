set platform_name  [lindex $argv 0]
set repo_directory [lindex $argv 1]
set sdk_directory  [lindex $argv 2]

set domain_name microblaze_standalone
set processor microblaze_0

setws $sdk_directory
repo -set $repo_directory

platform create -name $platform_name -hw $sdk_directory/$platform_name.xsa -proc $processor
domain create -name $domain_name -os standalone -proc $processor
platform generate

app create -name ${platform_name}_control -template "Empty Application" -domain $domain_name -lang c
importsources -name ${platform_name}_control -path ctrl/main.c
app build -name ${platform_name}_control

exit
