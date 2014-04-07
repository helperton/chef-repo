#
# Cookbook Name:: openstack
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "openstack-common"
include_recipe "openstack-controller::mysql-server"
include_recipe "openstack-controller::qpid-cpp-server"
include_recipe "openstack-controller::python-keystoneclient"
include_recipe "openstack-controller::openstack-keystone"
