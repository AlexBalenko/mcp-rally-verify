#!/bin/bash -xe

function prepare {
    cp /root/keystonerc /home
    cp debug /home
    cp install_tempest.sh /home
#    cp	ceph lvm skip_ceph.list skip_lvm.list /home

    V2_FIX=$(cat /home/keystonerc |grep v2.0| wc -l)
    if [ ${V2_FIX} == '0' ]; then
        sed -i 's|:5000|:5000/v2.0|g' /home/openrc
    else
        echo "openrc file already fixed"
    fi
    
    IS_TLS=$(source /root/keystonerc; openstack endpoint show identity 2>/dev/null | awk '/https/')
    #if [ "${IS_TLS}" ]; then
    #    cp /var/lib/astute/haproxy/public_haproxy.pem /home 
    #    echo "export OS_CACERT='/home/rally/public_haproxy.pem'" >> /home/openrc
    #fi
}

function install_docker_and_run {
    apt-get install -y docker.io
    apt-get install -y cgroup-bin
    docker pull rallyforge/rally:latest
    image_id=$(docker images | grep latest| awk '{print $3}')
    docker run --net host -v /home/:/home/rally -tid -u root $image_id
    docker_id=$(docker ps | grep $image_id | awk '{print $1}'| head -1)
}

function configure_tempest {
    NOVA_FLTR=$(sed -n '/scheduler_default_filters=/p' /etc/nova/nova.conf | cut -f2 -d=)
    check_ceph=$(cat /etc/cinder/cinder.conf |grep '\[RBD-backend\]' | wc -l)
    if [ ${check_ceph} == '1' ]; then
        storage_protocol="ceph"
    else
        storage_protocol="lvm"
    fi
    echo 'scheduler_available_filters = '$NOVA_FLTR >> $storage_protocol

    docker exec -ti $docker_id bash -c "./install_tempest.sh"
    docker exec -ti $docker_id bash -c "apt-get install -y vim"
    docker exec -ti $docker_id bash
}

prepare
install_docker_and_run
configure_tempest
