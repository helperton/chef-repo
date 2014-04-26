#
# Cookbook Name:: cobbler
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "openstack-common"
include_recipe "openstack-cobbler::cobbler"
# Take this out later
include_recipe "openstack-cobbler::firewall-down"
