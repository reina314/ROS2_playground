#!/bin/bash
set -e

# Always create admin with sudo
if ! id "admin" &>/dev/null; then
    useradd -m -s /bin/bash admin
    echo "admin:admin" | chpasswd
    usermod -aG sudo admin
    echo "admin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    mkdir -p /home/admin/my_ws/src
    chown -R admin:admin /home/admin/my_ws
    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/admin/.bashrc
    echo 'export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp' >> /home/admin/.bashrc
    echo 'export ROS_DOMAIN_ID=42' >> /home/admin/.bashrc
fi

# Create numbered users
for i in $(seq 1 $NUM_USERS); do
    username="user$i"
    if ! id "$username" &>/dev/null; then
        useradd -m -s /bin/bash "$username"
        echo "$username:$username" | chpasswd
        mkdir -p /home/$username/my_ws/src
        chown -R $username:$username /home/$username/my_ws
        echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/$username/.bashrc
        echo 'export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp' >> /home/$username/.bashrc
        echo 'export ROS_DOMAIN_ID=42' >> /home/$username/.bashrc
    fi
done

exec "$@"