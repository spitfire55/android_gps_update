FROM openjdk:8

# Install dependencies
RUN apt-get update && apt-get install -y curl wget unzip file git make byacc \
    bison flex
# Install expect for Android license scripting
COPY scripts/install_expect.sh /scripts/install_expect.sh
RUN /scripts/install_expect.sh

# Download Android SDK
COPY scripts/setup_android_sdk.sh /scripts/setup_android_sdk.sh
RUN /scripts/setup_android_sdk.sh
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=${PATH}:/scripts:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/tools

# Auto-accept Android SDK/NDK licenses scripts
COPY scripts/accept_license.sh /scripts/accept_license.sh
COPY scripts/accept_android_licenses.sh /scripts/accept_android_licenses.sh
RUN /scripts/accept_android_licenses.sh

# Install NDK and make standalone toolchain
ENV ANDROID_NDK "ndk-bundle" "cmake;3.6.4111459" "lldb;3.1"
RUN accept_license.sh "sdkmanager --verbose ${ANDROID_NDK}"
ENV ANDROID_NDK_HOME ${ANDROID_HOME}/ndk-bundle
ENV PATH=${ANDROID_NDK_HOME}:${PATH}

COPY Application.mk Android.mk gps_test.cpp hardware.c src/ /app/
COPY include/hardware /app/include/hardware
COPY include/cutils /app/include/cutils
COPY include/system /app/include/system
COPY include/log /app/include/log
COPY include/vndksupport /app/include/vndksupport
WORKDIR /app
ENV NDK_PROJECT_PATH /app
RUN ndk-build NDK_APPLICATION_MK=Application.mk NDK_APP_OUT=. TARGET_PLATFORM=android-27
