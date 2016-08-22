FROM beevelop/java

MAINTAINER Ranger.Huang <ranger.huang@ccplay.cc>

ENV ANDROID_SDK_URL="https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz" \
    ANDROID_BUILD_TOOLS_VERSION=23.0.3 \
    MAVEN_HOME="/usr/share/maven" \
    ANDROID_HOME="/opt/android-sdk-linux"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$MAVEN_HOME/bin

# Clean up
RUN dpkg --add-architecture i386 && \
    apt-get -qq update && \
    apt-get -qq install -y curl libncurses5:i386 libstdc++6:i386 zlib1g:i386 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Installs Android SDK
RUN curl -sL ${ANDROID_SDK_URL} | tar xz -C /opt && \
    echo y | android update sdk -a -u -t platform-tools,build-tools-${ANDROID_BUILD_TOOLS_VERSION} && \
    # clear $ANDROID_HOME/tools (700M)
    rm -rf $ANDROID_HOME/tools/* && \
    chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME

# image size 840M
