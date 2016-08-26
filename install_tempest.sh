#!/bin/bash -xe
sed -i 's|#swift_operator_role = Member|swift_operator_role = SwiftOperator|g' /etc/rally/rally.conf
source /home/rally/openrc
rally-manage db recreate
rally deployment create --fromenv --name=tempest 
rally verify install --version b39bbce80c69a57c708ed1b672319f111c79bdd5
rally verify genconfig
