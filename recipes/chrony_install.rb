# frozen_string_literal: true

#
# Cookbook Name:: aws-parallelcluster
# Recipe:: chrony_install
#
# Copyright 2013-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the
# License. A copy of the License is located at
#
# http://aws.amazon.com/apache2.0/
#
# or in the "LICENSE.txt" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
# OR CONDITIONS OF ANY KIND, express or implied. See the License for the specific language governing permissions and
# limitations under the License.

# Install Amazon Time Sync
package %w[ntp ntpdate ntp*] do
  action :remove
end

package %w[chrony] do
  retries 3
  retry_delay 5
end

append_if_no_line "add configuration to chrony.conf" do
  path node['cfncluster']['chrony']['conf']
  line "server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4"
  notifies :reload, "service[#{node['cfncluster']['chrony']['service']}]", :immediately
end

if node['init_package'] == 'init'
  chrony_reload_command = "service #{node['cfncluster']['chrony']['service']} force-reload"
elsif node['init_package'] == 'systemd'
  chrony_reload_command = "systemctl force-reload #{node['cfncluster']['chrony']['service']}"
end

service node['cfncluster']['chrony']['service'] do
  reload_command chrony_reload_command
  action :nothing
end
