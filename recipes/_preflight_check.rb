#
# Cookbook:: managed_automate
# Recipe:: _preflight_check
#

fs_file_max = shell_out('sysctl -n fs.file-max').stdout.strip.to_i
vm_max_map_count = shell_out('sysctl -n vm.max_map_count').stdout.strip.to_i
vm_dirty_ratio = shell_out('sysctl -n vm.dirty_ratio').stdout.strip.to_i
vm_dirty_background_ratio = shell_out('sysctl -n vm.dirty_background_ratio').stdout.strip.to_i
vm_dirty_expire_centisecs = shell_out('sysctl -n vm.dirty_expire_centisecs').stdout.strip.to_i

# PREFLIGHT-CHECK
if node['ma']['preflight-check']
  # fs.file-max is at least 64000
  sysctl 'fs.file-max' do
    value node['ma']['sysctl']['fs.file-max']
    not_if { fs_file_max > 64000 }
  end

  # vm.max_map_count must be at least 262144
  sysctl 'vm.max_map_count' do
    value node['ma']['sysctl']['vm.max_map_count']
    not_if { vm_max_map_count > 262144 }
  end

  # vm.dirty_ratio is between 5 and 30
  sysctl 'vm.dirty_ratio' do
    value node['ma']['sysctl']['vm.dirty_ratio']
    not_if { (vm_dirty_ratio > 5) && (vm_dirty_ratio < 30) }
  end

  # vm.dirty_background_ratio is between 10 and 60
  sysctl 'vm.dirty_background_ratio' do
    value node['ma']['sysctl']['vm.dirty_background_ratio']
    not_if { (vm_dirty_background_ratio > 10) && (vm_dirty_background_ratio < 60) }
  end

  # vm.dirty_expire_centisecs must be between 10000 and 30000
  sysctl 'vm.dirty_expire_centisecs' do
    value node['ma']['sysctl']['vm.dirty_expire_centisecs']
    not_if { (vm_dirty_expire_centisecs > 10000) && (vm_dirty_expire_centisecs < 30000) }
  end

  # additional sysctl values that need to be set
  sysctl 'net.ipv6.conf.all.accept_ra' do
    value node['ma']['sysctl']['net.ipv6.conf.all.accept_ra']
  end

  sysctl 'net.ipv6.conf.default.accept_ra' do
    value node['ma']['sysctl']['net.ipv6.conf.default.accept_ra']
  end

  sysctl 'net.ipv6.conf.all.accept_redirects' do
    value node['ma']['sysctl']['net.ipv6.conf.all.accept_redirects']
  end

  sysctl 'net.ipv6.conf.default.accept_redirects' do
    value node['ma']['sysctl']['net.ipv6.conf.default.accept_redirects']
  end

else

  # fs.file-max is at least 64000
  sysctl 'fs.file-max' do
    value node['ma']['sysctl']['fs.file-max']
    not_if { fs_file_max > 64000 }
    ignore_failure true
  end

  # vm.max_map_count must be at least 262144
  sysctl 'vm.max_map_count' do
    value node['ma']['sysctl']['vm.max_map_count']
    not_if { vm_max_map_count > 262144 }
    ignore_failure true
  end

  # vm.dirty_ratio is between 5 and 30
  sysctl 'vm.dirty_ratio' do
    value node['ma']['sysctl']['vm.dirty_ratio']
    not_if { (vm_dirty_ratio > 5) && (vm_dirty_ratio < 30) }
    ignore_failure true
  end

  # vm.dirty_background_ratio is between 10 and 60
  sysctl 'vm.dirty_background_ratio' do
    value node['ma']['sysctl']['vm.dirty_background_ratio']
    not_if { (vm_dirty_background_ratio > 10) && (vm_dirty_background_ratio < 60) }
    ignore_failure true
  end

  # vm.dirty_expire_centisecs must be between 10000 and 30000
  sysctl 'vm.dirty_expire_centisecs' do
    value node['ma']['sysctl']['vm.dirty_expire_centisecs']
    not_if { (vm_dirty_expire_centisecs > 10000) && (vm_dirty_expire_centisecs < 30000) }
    ignore_failure true
  end

  # additional sysctl values that need to be set
  sysctl 'net.ipv6.conf.all.accept_ra' do
    value node['ma']['sysctl']['net.ipv6.conf.all.accept_ra']
    ignore_failure true
  end

  sysctl 'net.ipv6.conf.default.accept_ra' do
    value node['ma']['sysctl']['net.ipv6.conf.default.accept_ra']
    ignore_failure true
  end

  sysctl 'net.ipv6.conf.all.accept_redirects' do
    value node['ma']['sysctl']['net.ipv6.conf.all.accept_redirects']
    ignore_failure true
  end

  sysctl 'net.ipv6.conf.default.accept_redirects' do
    value node['ma']['sysctl']['net.ipv6.conf.default.accept_redirects']
    ignore_failure true
  end
end

# Verify the installation is ready to run Automate 2
execute "#{node['ma']['chef-automate']} preflight-check --airgap" do
  not_if { ::File.exist?('/bin/chef-automate') }
  only_if { node['ma']['preflight-check'] }
end
