/* logging.h
 *
 * Copyright (C) 2006-2013 wolfSSL Inc.
 *
 * This file is part of CyaSSL.
 *
 * CyaSSL is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * CyaSSL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */

/* submitted by eof */


#ifndef CYASSL_LOGGING_H
#define CYASSL_LOGGING_H


#ifdef __cplusplus
    extern "C" {
#endif


enum  CYA_Log_Levels {
    ERROR_LOG = 0,
    INFO_LOG,
    ENTER_LOG,
    LEAVE_LOG,
    OTHER_LOG
};

typedef void (*CyaSSL_Logging_cb)(const int logLevel,
                                  const char *const logMessage);

CYASSL_API int CyaSSL_SetLoggingCb(CyaSSL_Logging_cb log_function);


#ifdef DEBUG_CYASSL

#  if defined CONFIG_APP && defined CONFIG_FACILITY_INCDNTLOG && defined CONFIG_INCDNTLOG_DEBUG_ENA

#    define CYASSL_ENTER(m) logCoreApi( \
    __FUNCTION__, \
    __LINE__, \
    eLogLevelDebug, \
    LOG_ALL_FLAGS_ON, \
    "CyaSSL Entering %s", m)

#    define CYASSL_LEAVE(m, r) logCoreApi( \
    __FUNCTION__, \
    __LINE__, \
    eLogLevelDebug, \
    LOG_ALL_FLAGS_ON, \
    "CyaSSL Leaving %s, return %d", m, r)

#    define CYASSL_ERROR(e) logCoreApi( \
    __FUNCTION__, \
    __LINE__, \
    eLogLevelDebug, \
    LOG_ALL_FLAGS_ON, \
    "CyaSSL error occured, error = %d", e )

#    define CYASSL_MSG(m) logCoreApi( \
    __FUNCTION__, \
    __LINE__, \
    eLogLevelDebug, \
    LOG_ALL_FLAGS_ON, \
    m )

#  else

      void CYASSL_ENTER(const char* msg);
      void CYASSL_LEAVE(const char* msg, int ret);

      void CYASSL_ERROR(int);
      void CYASSL_MSG(const char* msg);

#  endif

#else /* DEBUG_CYASSL   */

    #define CYASSL_ENTER(m)
    #define CYASSL_LEAVE(m, r)

    #define CYASSL_ERROR(e) 
    #define CYASSL_MSG(m)

#endif /* DEBUG_CYASSL  */

#ifdef __cplusplus
}
#endif

#endif /* CYASSL_MEMORY_H */
