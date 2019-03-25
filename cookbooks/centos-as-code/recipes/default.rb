execute "append to log" do
  command <<-EOF
    echo 'start new' > #{node['log-file']['path']}
    date >> #{node['log-file']['path']}
    echo ''  >> #{node['log-file']['path']}
    echo 'hostname: ' $(hostname)  >> #{node['log-file']['path']}
    echo 'version: ' $(cat /etc/centos-release)  >> #{node['log-file']['path']}
    echo $(ifconfig | grep 192)  >> #{node['log-file']['path']}
    echo ''  >> #{node['log-file']['path']}
  EOF
end

package 'vim-enhanced'