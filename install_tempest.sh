#!/bin/bash -xe
sed -i 's|#swift_operator_role = Member|swift_operator_role = SwiftOperator|g' /etc/rally/rally.conf
source /home/rally/keystonerc
rally-manage db recreate
rally deployment create --fromenv --name=tempest 
#rally verify install --add-options $storage_protocol
rally verify create-verifier --type tempest --name tempest-verifier
#rally verify genconfig
rally verify configure-verifier
