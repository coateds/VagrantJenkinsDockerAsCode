# default['log-file']['path'] = '/home/vagrant/chef_provision.log'
default['log-file']['path'] = '/vagrant/chef_provision.log'

default['hello_web']['package'] = 'httpd'
default['hello_web']['service'] = 'httpd'
default['hello_web']['docroot'] = '/var/www/html'

default['hosts']['jenkins'] = '192.168.16.5 jenkins.davecoate.com'
default['hosts']['gitlab'] = '192.168.16.8 gitlabce.davecoate.com'