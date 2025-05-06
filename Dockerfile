FROM ros:jazzy

# Set the number of user to create (default: 4)
ARG NUM_USERS=4
ENV NUM_USERS=${NUM_USERS}

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ~nros-${ROS_DISTRO}-rqt* \
    ros-${ROS_DISTRO}-demo-nodes-cpp \
    ros-${ROS_DISTRO}-demo-nodes-py \
    ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
    ros-${ROS_DISTRO}-turtlesim \
    openssh-server \
    xauth \
    git \
    sudo \
    vim \
    nano \
    terminator \
    && rm -rf /var/lib/apt/lists/*

# Setup SSH
RUN mkdir /var/run/sshd

# Create users and  their workspaces
COPY create_users.sh /usr/local/bin/create_users.sh
RUN chmod +x /usr/local/bin/create_users.sh

# Set SSH to allow password authentication and X11 forwarding
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config && \
    sed -i 's|#X11DisplayOffset 10|X11DisplayOffset 10|' /etc/ssh/sshd_config && \
    sed -i 's|#X11UseLocalhost yes|X11UseLocalhost no|' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

ENTRYPOINT [ "/usr/local/bin/create_users.sh" ]
CMD ["/usr/sbin/sshd", "-D"]