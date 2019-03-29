## Refactor 1
Adds recipes
* chef.add_recipe "centos-as-code::install-gradle"
* chef.add_recipe "centos-as-code::devops-apps"
* chef.add_recipe "centos-as-code::install-jenkins"

install-jenkins restores configuration from backup, including
* user and pw, logon as coateds
* plugins, including thin backup
* backup files in /vagrant (sync'd directory)

## Refactor 2
* Rename cookbook
* chef.add_recipe "jd-as-code::default"
* chef.add_recipe "jd-as-code::hosts-file"
* chef.add_recipe "jd-as-code::system-updates"
* chef.add_recipe "jd-as-code::tz"
* # chef.add_recipe "jd-as-code::install-gradle"
* chef.add_recipe "jd-as-code::devops-apps"
* chef.add_recipe "jd-as-code::install-jenkins"