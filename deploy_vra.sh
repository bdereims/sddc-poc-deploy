#!/bin/bash
#bdereims@vmware.com

[ "${1}" == "" ] && echo "usage: ${0} deploy_env" && exit 1
[ ! -f "${1}" ] && echo "error: file '${1}' does not exist" && exit 1

. ./"${1}"

### Local vars ####

HOSTNAME=vra
NAME=lab-cPod-vra
IP=192.168.1.42
OVA=${BITS}/VMware-vR-Appliance-7.1.0.710-4270058_OVF10_TechPreview.ova

###################

export MYSCRIPT=/tmp/$$

cat << EOF > ${MYSCRIPT}
ovftool --acceptAllEulas --X:injectOvfEnv --allowExtraConfig \
--prop:va-ssh-enabled=True \
--prop:vami.DNS.VMware_vRealize_Appliance=${DNS} \
--prop:vami.domain.VMware_vRealize_Appliance=${DOMAIN} \
--prop:vami.gateway.VMware_vRealize_Appliance=${GATEWAY} \
--prop:vami.hostname=${HOSTNAME} \
--prop:vami.ip0.VMware_vRealize_Appliance=${IP} \
--prop:vami.netmask0.VMware_vRealize_Appliance=${NETMASK} \
--prop:vami.searchpath.VMware_vRealize_Appliance=${DOMAIN} \
--prop:varoot-password=${PASSWORD} \
-ds=${DATASTORE} -n=${NAME} --network=${PORTGROUP} \
${OVA} \
vi://${ADMIN}:'${VC_PASSWORD}'@${TARGET}
EOF

sh ${MYSCRIPT}

rm ${MYSCRIPT}
