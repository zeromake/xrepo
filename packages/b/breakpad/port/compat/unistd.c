#include <windows.h>
#include "unistd.h"

int ftruncate(int fd, int64_t length) {
    BOOL ok = SetEndOfFile((HANDLE)_get_osfhandle(fd));
    return ok ? 0 : -1;
}

int getpagesize(void)
{
  SYSTEM_INFO system_info;
  GetSystemInfo (&system_info);
  return system_info.dwPageSize;
}
