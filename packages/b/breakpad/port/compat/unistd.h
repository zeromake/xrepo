#ifndef _UNISTD_H
#define _UNISTD_H
#include <io.h>
#include <process.h>
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
int ftruncate(int fd, int64_t length);
int getpagesize(void);


#ifdef __cplusplus
}
#endif

#endif /* _UNISTD_H */