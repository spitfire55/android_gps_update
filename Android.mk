LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include

LOCAL_SRC_FILES:= .*

LOCAL_MODULE:= test-gps

LOCAL_MODULE_TAGS := optional

include $(BUILD_EXECUTABLE)
