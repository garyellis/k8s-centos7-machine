import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'

def test_docker_running(host):
    assert host.service("docker").is_running

def test_kubelet_installed(host):
    kubelet = host.package("kubelet")
    assert kubelet.is_installed

def test_kubeadm_installed(host):
    kubeadm = host.package("kubeadm")
    assert kubeadm.is_installed
    assert kubeadm.version.startswith("1.17")