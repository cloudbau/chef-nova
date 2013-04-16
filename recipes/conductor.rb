include_recipe "nova::nova-common"

platform_options = node["nova"]["platform"]

platform_options["nova_conductor_packages"].each do |pkg|
  package pkg do
    action :upgrade
    options platform_options["package_overrides"]
  end
end

service "nova-conductor" do
  service_name platform_options["nova_conductor_service"]
  provider Chef::Provider::Service::Upstart if platform?("ubuntu")
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, resources(:template => "/etc/nova/nova.conf"), :delayed
end
