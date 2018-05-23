#/usr/bin/env bash
#
# Master example:
#  ./kubernetes_deploy.sh --master-ip=1.1.1.1 --master=true
#  
#  Node example: 
#  ./kubernetes_deploy.sh --master-ip=1.1.1.1 --master-token=d4e5f6 --master-hash=a1b2c3
#  Tokens and hashes are obviously a lot longer though
#  You can also use the port argument if relevant
#  
#  Parameters can be used with either --master-ip 1.1.1.1 or --master-ip=1.1.1.1

die() {
    printf '%s\n' "$1" >&2
    exit 1
}

printparse(){
    if [ ${VERBOSE} -gt 0 ]; then
        printf 'Parse: %s%s%s\n' "$1" "$2" "$3" >&2;
    fi
}

showme(){
    if [ ${VERBOSE} -gt 0 ]; then
        printf 'VERBOSE: %s\n' "$1" >&2;
    fi
}


# Settings & Defaults
VERBOSE=0
master_ip=""
master_port=6443
master_token=""
master_hash=""
master_deploy=false

##################
# BLOCK CONFIG   #
##################
optspec=":vhl:t:-:"
while getopts "$optspec" OPTCHAR; do

    showme "OPTARG:  ${OPTARG[*]}"
    showme "OPTIND:  ${OPTIND[*]}"
    case "${OPTCHAR}" in
        -)
            case "${OPTARG}" in
                master)
                    opt=${OPTARG}
                    val="${$OPTIND"
                    showme "OPTIND is {$OPTIND} {!OPTIND} has value \"${!OPTIND}\""
                    if [[ "$val" == -* ]]; then
                       die "ERROR: $opt value must not have dash at beginning"
                    fi
                    ## OPTIND=$(( $OPTIND + 1 )) # CAUTION! no effect?
                    master_deploy"${val}"
                    shift
                    ;;
                master=*) #argument has equal sign
                    opt=${OPTARG%=*}
                    val=${OPTARG#*=}
                    if [ "${OPTARG#*=}" ]; then
                        printparse "--${opt}" "=" "${val}"
                           master_deploy="${val}"
                           ## shift CAUTION don't shift this, fails othewise
                    else
                        die "ERROR: $opt value must be supplied"
                    fi
                    ;;
                master-ip) #argument has no equal sign
                    opt=${OPTARG}
                    val="${!OPTIND}"
                    ## check value. If negative, assume user forgot value
                    showme "OPTIND is {$OPTIND} {!OPTIND} has value \"${!OPTIND}\""
                    if [[ "$val" == -* ]]; then
                        die "ERROR: $opt value must not have dash at beginning"
                    fi
                    ## OPTIND=$(( $OPTIND + 1 )) # CAUTION! no effect?
                    printparse "--${OPTARG}" "  " "${val}"
                    master_ip="${val}"
                    shift
                    ;;
                master-ip=*) #argument has equal sign
                    opt=${OPTARG%=*}
                    val=${OPTARG#*=}
                    if [ "${OPTARG#*=}" ]; then
                        printparse "--${opt}" "=" "${val}"
                        master_ip="${val}"
                        ## shift CAUTION don't shift this, fails othewise
                    else
                        die "ERROR: $opt value must be supplied"
                    fi
                    ;;
                master-port) #argument has no equal sign
                    opt=${OPTARG}
                    val="${!OPTIND}"
                    ## check value. If negative, assume user forgot value
                    showme "OPTIND is {$OPTIND} {!OPTIND} has value \"${!OPTIND}\""
                    if [[ "$val" == -* ]]; then
                        die "ERROR: $opt value must not have dash at beginning"
                    fi
                    ## OPTIND=$(( $OPTIND + 1 )) #??
                    printparse "--${opt}" " " "${val}"
                    master_port="${val}"
                    shift
                    ;;
                master-port=*) #argument has equal sign
                    opt=${OPTARG%=*}
                    val=${OPTARG#*=}
                    if [ "${OPTARG#*=}" ]; then
                        master_port=${val}
                        printparse "--$opt" " -> " "$toc"
                        ##shift ## NO! dont shift this
                    else
                        die "ERROR: value for $opt undefined"
                    fi
                    ;;
                master-token) #argument has no equal sign
                    opt=${OPTARG}
                    val="${!OPTIND}"
                    ## check value. If negative, assume user forgot value
                    showme "OPTIND is {$OPTIND} {!OPTIND} has value \"${!OPTIND}\""
                    if [[ "$val" == -* ]]; then
                        die "ERROR: $opt value must not have dash at beginning"
                    fi
                    ## OPTIND=$(( $OPTIND + 1 )) #??
                    printparse "--${opt}" " " "${val}"
                    master_token="${val}"
                    shift
                    ;;
                master-token=*) #argument has equal sign
                    opt=${OPTARG%=*}
                    val=${OPTARG#*=}
                    if [ "${OPTARG#*=}" ]; then
                        master_token=${val}
                        printparse "--$opt" " -> " "$toc"
                        ##shift ## NO! dont shift this
                    else
                        die "ERROR: value for $opt undefined"
                    fi
                    ;;
                master-hash) #argument has no equal sign
                    opt=${OPTARG}
                    val="${!OPTIND}"
                    ## check value. If negative, assume user forgot value
                    showme "OPTIND is {$OPTIND} {!OPTIND} has value \"${!OPTIND}\""
                    if [[ "$val" == -* ]]; then
                        die "ERROR: $opt value must not have dash at beginning"
                    fi
                    ## OPTIND=$(( $OPTIND + 1 )) #??
                    printparse "--${opt}" " " "${val}"
                    master_hash="${val}"
                    shift
                    ;;
                master-hash=*) #argument has equal sign
                    opt=${OPTARG%=*}
                    val=${OPTARG#*=}
                    if [ "${OPTARG#*=}" ]; then
                        master_hash=${val}
                        printparse "--$opt" " -> " "$toc"
                        ##shift ## NO! dont shift this
                    else
                        die "ERROR: value for $opt undefined"
                    fi
                    ;;
                help)
                    echo "usage: $0 [-v] [--master-ip[=]<ip>] [--master-port[=]<port>]" >&2
                    exit 2
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        h|-\?|--help)
            ## must rewrite this for all of the arguments
            echo "usage: $0 [-v] [--master-ip[=]<ip>] [--master-port[=]<port>]" >&2
            exit 2
            ;;
        i)
            master_ip=${OPTARG}
            printparse "-l" " "  "${master-ip}"
            ;;
        p)
            master_port=${OPTARG}
            ;;
        v)
            VERBOSE=1
            ;;

        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done
####################
# END CONFIG BLOCK #
####################

# Print settings for confirmation
printf "Values:\n"
printf "master-ip:    $master_ip \n" 
printf "master-port:  $master_port \n"
printf "master-token: $master_token \n"
printf "master-hash:  $master_hash \n"

# Both master and node configs need to know master IP
# for broadcast & join reasons
if [[ -z "$master_ip" ]]; then
    die "ERROR: Master IP not defined"
fi

# If node, then check if hash and token are set
# No validation going on here though
if [[ "$master_deploy" = false ]]; then
if [[ -z "$master_token" ]]; then
    die "ERROR: Master token not defined"
fi
if [[ -z "$master_hash" ]]; then
    die "ERROR: Master hash not defined"
fi
fi

# It's important that yo
printf "\n"
read -p "Warning: The script must be run as root and requires a kubernetes user, press enter to continue."
printf "\n"

yum -y update

####################
# Kubernetes setup #
####################
# Disable Firewall (TEMP)
systemctl disable firewalld
systemctl stop firewalld

# Install docker, NFS client
yum -y install docker nfs-utils glusterfs-fuse
systemctl enable docker
systemctl start docker

# Import kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Disable SELinux, for both session and permanently
setenforce 0
cat <<EOF > /etc/selinux/config
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=permissive
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
EOF

# Install kubernetes tools and enable / start
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet
	
# net.bridge.bridge-nf-call-iptables Hotfix
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system	

systemctl daemon-reload
systemctl restart kubelet

# MASTER
# Non-admin create user
if [[ "$master_deploy" = true ]]; then
    printf "\n"
    kubeadm init --apiserver-advertise-address=$master_ip --pod-network-cidr=10.244.0.0/16

    mkdir -p /home/kubernetes/.kube
    cp -i /etc/kubernetes/admin.conf /home/kubernetes/.kube/config
    chown kubernetes:kubernetes /home/kubernetes/.kube/config

    printf "\n\nValidate using kubectl get pods --all-namespaces\n\n"
    read -p "Press enter to continue"

    su kubernetes -c 'kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml'
    su kubernetes && cd /home/kubernetes
else
# Join node
    kubeadm join --token $master_token $master_ip:$master_port --discovery-token-ca-cert-hash $master_hash
fi

# For non hard-coded kubernetes user
# mkdir -p $HOME/.kube
# cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# chown $(id -u):$(id -g) $HOME/.kube/config 
