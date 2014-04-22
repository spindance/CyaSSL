
# ==============================================================================#=
# FILE:
#   Makefile
#
# DESCRIPTION:
#   Builds the CyaSSL library.
# ------------------------------------------------------------------------------+-
# Copyright (c) 2013 SpinDance Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# ==============================================================================#=

# ------------------------------------------------------------------------------+-
# make menuconfig
#
# Support integration with projects that use "make menuconfig" for project level
# customization.
#
# The toplevel project Makefile creates a project-wide ".config" file for use
# in lower level projects like this one.  The ".config" file is typically 
# created via "make menuconfig", "make nconfig", or "make alldefconfig".
#
# ------------------------------------------------------------------------------+-

-include $(DOT_CONFIG_FILE)

#
# Define a function to strip quotes from variables defined in .config
#
unquote = $(subst $\",,$1)

ifeq ($(CONFIG_CONFIGURED),y)
    ifeq ($(CONFIG_QUIET_BUILD),y)
        export Q ?= @
    else
        export Q ?= #@
    endif
else
     #
     # Quiet vs. verbose: to make things verbose, put a # in front of the @
     #
     # Quiet:
     # Q = @
     # Verbose:
     # Q = #@
     #
     # When we don't have a command line Q setting
     #   e.g. $ make help Q=@
     # and we don't have a .config file
     #   e.g. $ make nconfig
     #        $ make help
     # we default to a quiet make.
     #
     export Q ?= @
endif


ifeq ($(CONFIG_CONFIGURED),y)

    #
    # CONFIG_CONFIGURED==y when we have a .config file so use it's values
    #
    # Dequote the .config strings before use.  Defines in .config start
    # with CONFIG_
    #
    CROSS_COMPILE ?= $(call unquote,$(CONFIG_CROSS_COMPILE))
    TOOLCHAIN_MCPU_EQ        = $(call unquote,$(CONFIG_TOOLCHAIN_MCPU_EQ))
    TOOLCHAIN_MARCH_EQ       = $(call unquote,$(CONFIG_TOOLCHAIN_MARCH_EQ))
    TOOLCHAIN_MFLOAT_ABI_EQ  = $(call unquote,$(CONFIG_TOOLCHAIN_MFLOAT_ABI_EQ))
    TOOLCHAIN_MFPU_EQ        = $(call unquote,$(CONFIG_TOOLCHAIN_MFPU_EQ))
    TOOLCHAIN_OPTIMISATION   = $(call unquote,$(CONFIG_TOOLCHAIN_OPTIMISATION))

else
    #
    # We don't have .config file so use good defaults
    #
    CROSS_COMPILE           ?= arm-none-eabi-
    TOOLCHAIN_MCPU_EQ        = -mcpu=cortex-m3
    TOOLCHAIN_MARCH_EQ       =
    TOOLCHAIN_MFLOAT_ABI_EQ  =
    TOOLCHAIN_MFPU_EQ        =
    TOOLCHAIN_OPTIMISATION   =

endif

# PROJECT_DIR is the current directory name without the full path
PROJECT_DIR=$(notdir $(CURDIR))

# Convention for where the build detritus ends up
#
# We build a tree of object files (.o) and dependancy files 
# in $(OBJ_DIR).
#
# The tree matches the structure of the source tree.
#
TOP_BUILD_DIR   = obj/

ifeq ($(OBJ_DIR),)
OBJ_DIR=$(TOP_BUILD_DIR)
endif

BUILD_DIR	= $(OBJ_DIR)$(PROJECT_DIR)/

include makedefs

GIT_REPO_PATH=git@github.com:/spindance/

# Source repostiories

THIS_REPO=cyassl

REPO_LIST-y =
REPO_LIST-y += ../$(THIS_REPO)

export REPO_LIST = $(REPO_LIST-y)

# Where we get pieces from...
INCLUDE_DIRS-$(CONFIG_APP)                     += -I../$(APP_DIR)/include
INCLUDE_DIRS-$(CONFIG_APP)                     += -I../$(APP_DIR)/include/generated
INCLUDE_DIRS-$(CONFIG_APP)                     += -I../$(APP_DIR)/source
INCLUDE_DIRS-$(CONFIG_QUICKSTART)              += -I../$(QUICKSTART_DIR)/include
INCLUDE_DIRS-$(CONFIG_QUICKSTART)              += -I../$(QUICKSTART_DIR)/include/generated
INCLUDE_DIRS-$(CONFIG_QUICKSTART)              += -I../$(QUICKSTART_DIR)/source
INCLUDE_DIRS-y                                 += -I.
INCLUDE_DIRS-y                                 += -I$(RTOS_SOURCE_DIR)/include
INCLUDE_DIRS-$(CONFIG_FREERTOS_PORT_ARM_CM3)   += -I$(RTOS_SOURCE_DIR)/portable/GCC/ARM_CM3
INCLUDE_DIRS-$(CONFIG_FREERTOS_PORT_ARM_CM4F)  += -I$(RTOS_SOURCE_DIR)/portable/GCC/ARM_CM4F
INCLUDE_DIRS-y                                 += -I$(LWIP_SOURCE_DIR)/include
INCLUDE_DIRS-y                                 += -I$(LWIP_SOURCE_DIR)/include/ipv4
INCLUDE_DIRS-y                                 += -I$(LWIP_CONTRIB_PORTS_SOURCE_DIR)/include/LM3S
INCLUDE_DIRS-y                                 += -I$(STM32PERIPHERALLIB_DRIVER_INCLUDE)
INCLUDE_DIRS-y                                 += -I$(STM32PERIPHERALLIB_CMSIS_INCLUDE)
INCLUDE_DIRS-y                                 += -I$(STM32PERIPHERALLIB_CMSIS_DEVICE_INCLUDE)

# C Source files
SOURCE-y   := 
SOURCE-y   += src/internal.c
SOURCE-y   += src/io.c
SOURCE-y   += src/keys.c
SOURCE-y   += src/ssl.c
SOURCE-y   += src/tls.c
SOURCE-y   += ctaocrypt/src/hmac.c
SOURCE-y   += ctaocrypt/src/random.c
SOURCE-y   += ctaocrypt/src/sha256.c
SOURCE-y   += ctaocrypt/src/logging.c
SOURCE-y   += ctaocrypt/src/error.c
SOURCE-y   += ctaocrypt/src/memory.c
SOURCE-y   += ctaocrypt/src/rsa.c
SOURCE-y   += ctaocrypt/src/dh.c
SOURCE-y   += ctaocrypt/src/asn.c
SOURCE-y   += ctaocrypt/src/coding.c
SOURCE-y   += ctaocrypt/src/aes.c
SOURCE-y   += ctaocrypt/src/des3.c
SOURCE-y   += ctaocrypt/src/pwdbased.c
SOURCE-y   += ctaocrypt/src/sha.c
SOURCE-y   += ctaocrypt/src/arc4.c
SOURCE-y   += ctaocrypt/src/md5.c
SOURCE-y   += ctaocrypt/src/integer.c
SOURCE-y   += ctaocrypt/src/port.c

SOURCE := $(SOURCE-y)

EXCLUDED_SRC :=

SOURCE := $(filter-out $(EXCLUDED_SRC), $(SOURCE))

# Misc. executables.
RM=/bin/rm
DOXYGEN=/usr/bin/doxygen

#
# The flags passed to the compiler.
#
CFLAGS-y                              = 
CFLAGS-$(CONFIG_TOOLCHAIN_USE_MTHUMB) += "-mthumb"
CFLAGS-y                              += $(TOOLCHAIN_MCPU_EQ)
CFLAGS-y                              += $(TOOLCHAIN_MARCH_EQ)
CFLAGS-y                              += $(TOOLCHAIN_MFLOAT_ABI_EQ)
CFLAGS-y                              += $(TOOLCHAIN_MFPU_EQ)
CFLAGS-y                              += $(TOOLCHAIN_OPTIMISATION)
CFLAGS-y                              += -ffunction-sections
CFLAGS-y                              += -fdata-sections
CFLAGS-y                              += -std=c99
CFLAGS-y                              += -c
CFLAGS-$(CONFIG_TOOLCHAIN_PEDANTIC)   += -pedantic
CFLAGS-$(CONFIG_TOOLCHAIN_WALL)       += -Wall
CFLAGS-$(CONFIG_TOOLCHAIN_VERBOSE)    += --verbose
CFLAGS-$(CONFIG_TOOLCHAIN_DEBUG)      += -g

CFLAGS = $(CFLAGS-y)

#
# The following are needed by stm32f4xx.h in the STM Std Perihperal Driver CMSIS code
#
CPPFLAGS-$(CONFIG_STM32F40_41XXX)       += -D"STM32F40_41xxx" 
CPPFLAGS-$(CONFIG_STM32F427_437XX)      += -D"STM32F427_437xx"
CPPFLAGS-$(CONFIG_STM32F429_439XX)      += -D"STM32F429_439xx"
CPPFLAGS-$(CONFIG_STM32F401XX)          += -D"STM32F401xx"    

CPPFLAGS-y                              += -D"USE_STDPERIPH_DRIVER"
CPPFLAGS-y                              += -D"USE_STM324xG_EVAL"
CPPFLAGS-y                              += -D USE_FLOATING_POINT
CPPFLAGS-y                              += $(INCLUDE_DIRS-y)

CFLAGS += $(CPPFLAGS-y)

DEPS = $(addprefix $(BUILD_DIR), $(SOURCE:.c=.d))
OBJS = $(addprefix $(BUILD_DIR), $(SOURCE:.c=.o))


SEP = '-----------------------------------------------------------------------+-'


.PHONY: all

all: $(OBJ_DIR)cyassl.a
	@# This line prevents warning when nothing to be done for all.

ifndef MAKECMDGOALS
-include $(DEPS)
else
ifneq ($(MAKECMDGOALS),$(filter $(MAKECMDGOALS),\
"help repos repostatus \
menuconfig clean distclean config nconfig menuconfig \
oldconfig silentoldconfig savedefconfig allnoconfig allyesconfig \
alldefconfig randconfig listnewconfig olddefconfig "))
#
# Include the dependencies if they are available
# and we are not invoked with one of the targets:
#
# help repos repostatus
# menuconfig clean distclean config nconfig menuconfig oldconfig 
# silentoldconfig savedefconfig allnoconfig allyesconfig alldefconfig randconfig 
# listnewconfig olddefconfig     
#
# .e.g.
#
# make clean
# -or-
# make distclean
#
-include $(DEPS)
endif
endif

$(OBJ_DIR)cyassl.a: $(OBJS)
	@echo "+--$(AR) $@"
	$(Q)$(AR) -rc $@ $^

# automatically generate dependency rules

$(BUILD_DIR)%.d : %.c
	@echo "+--Generating Dependency $@"
	$(Q)mkdir -p $(dir $@)
	$(Q)$(CC) $(CFLAGS) -MF"$@" -MG -MM -MT"$@" -MT"$(@:.d=.o)" "$<"

#
# -MF  write the generated dependency rule to a file
# -MG  assume missing headers will be generated and don't stop with an error
# -MM  generate dependency rule for prerequisite, skipping system headers
# -MP  add phony target for each header to prevent errors when header is missing
# -MT  add a target to the generated dependency
# 
# "$@" is the target (the thing on the left side of the : )
# "$<" is the prerequisite (the thing on the right side of the : ). 
# The expression "$(<:.c=.o)" replaces the .c extension with .o.
#
# The trick here is to generate the rule with two targets by adding -MT twice; 
# this makes both the .o file and the .d file depend on the source file 
# and its headers; that way the dependency file gets automatically regenerated 
# whenever any of the corresponding .c or .h files are changed.
#
# The -MG and -MP options keep make from freaking out if a header file is missing.
#
# We've removed the -MP option to keep make from infinite looping within the
# dependency generation.
#

.PHONY: clean
clean :
ifneq ($(strip $(OBJ_DIR)),)
	@echo $(SEP)
	@echo "+--cyassl library clean"
	@echo $(SEP)
	$(RM) -rf obj/*
	$(RM) -rf mfgObj/*
else
	$(Q)echo "OBJ_DIR is not defined or empty, can't clean."
endif

.PHONY: distclean
distclean : clean
	@echo $(SEP)
	@echo "+--cyassl library distclean"
	@echo $(SEP)
	find . -name "*~" -exec rm -f {} \;
	find . -name "*.o" -exec rm -f {} \;

.PHONY: help
help :
	$(Q)echo ""
	$(Q)echo "make help             - Print this message."
	$(Q)echo "make                  - Build the executable software"
	$(Q)echo "make all              - Build the executable software - same as \"make\""
	$(Q)echo "make clean            - Clean build products"
	$(Q)echo "make distclean        - Clean to repository distribution clean. Removes .config and autoconf.h"



.PHONY: DUMPVARS
DUMPVARS :
	@echo ""
	@echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|@"
	@echo "DUMPVARS"
	@echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|@"
	@echo "DOT_CONFIG_FILE: $(DOT_CONFIG_FILE)"
	@echo "CURDIR:          $(CURDIR)"
	@echo "PROJECT_DIR:     $(PROJECT_DIR)"
	@echo "TOP_BUILD_DIR:   $(TOP_BUILD_DIR)"
	@echo "BUILD_DIR:       $(BUILD_DIR)"
	@echo ""
	@echo "SOURCE:          $(SOURCE)"
	@echo "DEPS:            $(DEPS)"
	@echo "OBJS:            $(OBJS)"
	@echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|@"
	@echo ""

