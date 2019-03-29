execute "append to log" do
  command <<-EOF
    echo #{node['hosts']['gitlab']} >> /etc/hosts
  EOF
end

