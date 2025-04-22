FROM ros:jazzy

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-demo-nodes-cpp \
    ros-${ROS_DISTRO}-demo-nodes-py \
    ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
    openssh-server \
    git \
    sudo \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Setup SSH
RUN mkdir /var/run/sshd

# Create users and workspaces
ARG USERS="user1 user2 user3"
RUN for user in $USERS; do \
    useradd -m -s /bin/bash $user && \
    echo "$user:$user" | chpasswd && \
    mkdir -p /home/$user/my_ws/src && \
    chown -R $user:$user /home/$user/my_ws && \
    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/$user/.bashrc && \
    echo 'export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp' >> /home/$user/.bashrc && \
    echo 'export ROS_DOMAIN_ID=42' >> /home/$user/.bashrc; \
    done

# Add 'admin' user with sudo privileges
RUN useradd -m -s /bin/bash admin && \
    echo "admin:admin" | chpasswd && \
    usermod -aG sudo admin && \
    echo "admin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/admin/my_ws/src && \
    chown -R admin:admin /home/admin/my_ws && \
    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/admin/.bashrc && \
    echo 'export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp' >> /home/admin/.bashrc && \
    echo 'export ROS_DOMAIN_ID=42' >> /home/admin/.bashrc

# Set SSH to allow password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Start SSH by default
CMD ["/usr/sbin/sshd", "-D"]