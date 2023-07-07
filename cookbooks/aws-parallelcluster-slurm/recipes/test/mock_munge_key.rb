munge_user_dir = "/home/#{node['cluster']['cluster_user']}/.munge"
directory munge_user_dir do
  mode '1777'
end

file "#{munge_user_dir}/.munge.key" do
  content 'munge-key'
  owner node['cluster']['munge']['user']
  group node['cluster']['munge']['group']
end
