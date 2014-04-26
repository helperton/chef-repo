#
# Cookbook Name:: openstack
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "openstack-common::hostname" 
include_recipe "openstack-common::networking" 
include_recipe "openstack-common::epel_repo" 
include_recipe "openstack-common::openstack-icehouse_repo" 
include_recipe "openstack-common::mysql-client" 
include_recipe "openstack-common::ntp" 
include_recipe "openstack-common::lsof" 
include_recipe "openstack-common::wget" 
include_recipe "openstack-common::openssl" 
include_recipe "openstack-common::tcpdump" 
include_recipe "openstack-common::rsync" 
include_recipe "openstack-common::expect" 
include_recipe "openstack-common::man" 
include_recipe "openstack-common::openstack-utils" 
include_recipe "openstack-common::openstack-selinux" 
