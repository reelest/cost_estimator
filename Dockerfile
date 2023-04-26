FROM ubuntu:18.04
   
# Prerequisites
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-11-jdk wget

WORKDIR /home/
   
# Prepare Android directories and system variables
ENV ANDROID_SDK_ROOT /home/android-sdk-linux
RUN mkdir -p .android && touch .android/repositories.cfg
   
# Set up Android SDK
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
RUN unzip -d android-sdk-linux android-sdk.zip > /dev/null && cd android-sdk-linux && mv cmdline-tools tools && mkdir cmdline-tools && mv tools cmdline-tools && cd ..
RUN yes | android-sdk-linux/cmdline-tools/tools/bin/sdkmanager "cmdline-tools;latest" "build-tools;29.0.3" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29" > /dev/null

RUN export ANDROID_HOME=$PWD/android-sdk-linux
RUN yes | android-sdk-linux/cmdline-tools/tools/bin/sdkmanager --licenses > /dev/null
ENV PATH "$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/flutter/bin"
   
# Run basic check to download Dark SDK
RUN flutter doctor

# The final step is run locally. We must run a