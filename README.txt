
================================================================================================#=
FILE:
    README.txt

LOCATION:
    <ProjRoot>/cyassl/buildEmbedded/

DESCRIPTION:
    Directory for building the CyaSSL library (static link)
    on an embedded platform with LwIP and FreeRTOS.
================================================================================================#=

========================================================================#=
Instructions
========================================================================#=
cd buildEmbedded


========================================================================#=
Log of Changes
========================================================================#=
Created custom Makefile modeled after the one for printf2.

Made configuration changes in cyassl/cyassl/ctaocrypt/settings.h
    #define FREERTOS
    #define CYASSL_LWIP
    #define CYASSL_STM32F2  (no choice for STM32F4)
    Removed:
        #define KEIL_INTRINSICS

Changed a number of source files to include stmf4xx*.h rather than stmf2xx*.h files.

Pruned the original source tree to include necessary files in:
    cyassl/src/
    cyassl/ctaocrypt/src
    cyassl/cyassl            (header files)
    cyassl/cyassl/ctaocrypt  (header files)

Added:
    cyassl/obj
    cyassl/sys/uio.h  # just as we did for rabbitmq-c



<eof>
