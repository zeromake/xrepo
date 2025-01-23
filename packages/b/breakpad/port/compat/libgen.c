#include <string.h>
#include "libgen.h"

#if defined(_WIN32) || defined(__DJGPP__) || defined(__MINGW32__)
#  define IS_PATH_SEPARATOR(c) (((c) == '/') || ((c) == '\\'))
#else
#  define IS_PATH_SEPARATOR(c) ((c) == '/')
#endif

const char* basename(const char* s) {
    const char* rv;
    if (!s || !*s)
        return ".";

    rv = s + strlen(s) - 1;
    do {
        if (IS_PATH_SEPARATOR(*rv))
        return rv + 1;
        --rv;
    } while (rv >= s);
    return s;
}

char* dirname(char* path)
{
  char* p;
  if (path == NULL || *path == '\0')
    return ".";
  p = path + strlen(path) - 1;
  while (IS_PATH_SEPARATOR(*p)) {
    if (p == path)
      return path;
    *p-- = '\0';
  }
  while (p >= path && !IS_PATH_SEPARATOR(*p))
    p--;
  if (p < path)
    return ".";
  if (p == path)
    return "/";
  *p = '\0';
  return path;
}
