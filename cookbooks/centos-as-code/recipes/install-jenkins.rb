execute 'log header' do
  command <<-EOF
    echo '*********'  >> #{node['log-file']['path']}
    echo 'install-jenkins recipe' >> #{node['log-file']['path']}
    echo ''  >> #{node['log-file']['path']}
  EOF
end

# Not necessary if installed with the install-gradle recipe
package %w(java-1.8.0-openjdk epel-release)

# Can't be done like this
# remote_file '/etc/pki/rpm-gpg/jenkins-ci.org.key' do
#   source 'https://jenkins-ci.org/redhat/jenkins-ci.org.key'
#   action :create
# end

# Jenkins package uses a key with a name:  Kohsuke Kawaguchi <kkawaguchi@cloudbees.com>
# rpm -qi gpg-pubkey-\* | grep -E ^Packager

execute 'add jenkins key' do
  command 'rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key'
  not_if 'rpm -qi gpg-pubkey-\* | grep kkawaguchi@cloudbees.com'
end

file "/etc/yum.repos.d/jenkins.repo" do
  content "[jenkins]
name=Jenkins-stable
baseurl=http://pkg.jenkins.io/redhat-stable
gpgcheck=1
"
end

#package 'jenkins-2.121.1'
#
#execute 'restore backup' do
#  command 'cp -rp /vagrant/jenkins-backup/* /var/lib/jenkins'
#end

# install jenkins
# and notify the restore backup job to run
package 'jenkins-2.121.1' do
  notifies :run, 'execute[restore backup]'
end

# This MUST be made idempotent...
# or even better, made to run only as notified by jenkins package installation
# else it could overwrite config changes made after install
execute 'restore backup' do
  command 'cp -rp /vagrant/jenkins-backup/* /var/lib/jenkins'
  action :nothing
end

service 'jenkins' do
  action [ :enable, :start ]
end

# The PW file does not show up on the first pass... race condition??
execute 'initial jenkins logon' do 
  command <<-EOF
    cat /var/lib/jenkins/secrets/initialAdminPassword >> #{node['log-file']['path']}
  EOF
  only_if { ::File.exist?('/var/lib/jenkins/secrets/initialAdminPassword') }
end

# default workspace is /var/lib/jenkins

# execute 'copy' do 
#   command <<-EOF
#     cat /var/lib/jenkins/secrets/initialAdminPassword >> #{node['log-file']['path']}
#   EOF
#   only_if { ::File.exist?('/var/lib/jenkins/secrets/initialAdminPassword') }
# end