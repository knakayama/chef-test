#
# Cookbook Name:: php-env
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

yum_repository "remi" do
    description "Les RPM de Remi - Repository"
    baseurl "http://rpms.famillecollet.com/enterprise/6/remi/x86_64/"
    gpgkey "http://rpms.famillecollet.com/RPM-GPG-KEY-remi"
    fastestmirror_enabled true
    action :create
end

yum_repository "remi-php55" do
    description "Les RPM de remi de PHP 5.5 pour Enterprise Linux 6"
    baseurl "http://rpms.famillecollet.com/enterprise/6/php55/$basearch/"
    gpgkey "http://rpms.famillecollet.com/RPM-GPG-KEY-remi"
    fastestmirror_enabled true
    action :create
end

# remove default httpd packages due to resolve conflicts
%w{httpd httpd-tools}.each do |pkg|
    package pkg do
        action :remove
    end
end

%w{php55-php php55-php-fpm php55-php-opcache}.each do |pkg|
    package pkg do
        action :install
        notifies :restart, "service[php55-php-fpm]"
    end
end

template "www.conf" do
    path "/etc/php-fpm.d/www.conf"
    source "www.conf.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :reload, "service[php55-php-fpm]"
end

service "php55-php-fpm" do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
end

