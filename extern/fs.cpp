#include <iostream>
#include "util/numerics/mpz.h"
#include "library/vm/vm_io.h"
#include "library/vm/vm.h"
#include "library/vm/vm_ptr.h"
#include "init/init.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

extern "C++" {
// static lean::environment * g_env = nullptr;
namespace lean {
    vm_obj mk_vm_ptr(void * data, vm_obj destructor);
}
}

extern "C" {
lean::vm_obj put_int(lean::vm_obj const & iptr, lean::vm_obj const &) {
    int i = *lean::to_raw_ptr<int>(iptr);
    std::cout << i;
    return lean::mk_vm_simple(0);
}

lean::vm_obj putstr(lean::vm_obj const & s, lean::vm_obj const &) {
   char *str = lean::to_raw_ptr<char>(s);
   std::cout << str;
   return lean::mk_vm_simple(0);
}

lean::vm_obj open_file(lean::vm_obj const & str_ptr, lean::vm_obj const &) {
    char *path = (char*)pointer_from_vm_array(str_ptr);
    int *fd = new int;
    *fd = open(path, O_RDONLY);
    std::cout << "file descriptor is: " << *fd << std::endl;
    return lean::mk_vm_ptr((void*)fd, lean::mk_vm_simple(0));
}

lean::vm_obj read_file(
    lean::vm_obj const & file_ptr,
    lean::vm_obj const & str_ptr,
    lean::vm_obj const & count_ptr,
    lean::vm_obj const &)
{
    std::cout << "read-file" << std::endl;
    int fd = *lean::to_raw_ptr<int>(file_ptr);
    void *buffer = pointer_from_vm_array(str_ptr);
    size_t count = (size_t)*lean::to_raw_ptr<int>(count_ptr);
    size_t bytes_read = read(fd, buffer, count);
    return lean::mk_vm_simple(0);
}
}
