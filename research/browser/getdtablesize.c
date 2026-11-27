#include <unistd.h>

/* The Unix process library references this BSD function. In the browser
 * the compiler only uses in-process operations and does not launch tools. */
int getdtablesize(void) {
    return (int) sysconf(_SC_OPEN_MAX);
}
