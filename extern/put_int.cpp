#include <iostream>
#include "util/numerics/mpz.h"
#include "library/vm/vm_io.h"
#include "library/vm/vm.h"
#include "library/vm/vm_ptr.h"
#include "init/init.h"

// static lean::environment * g_env = nullptr;

extern "C" {
lean::vm_obj put_int(lean::vm_obj const & iptr, lean::vm_obj const &) {
    int i = *lean::to_raw_ptr<int>(iptr);
    std::cout << i;
    return lean::mk_vm_simple(0);
}

lean::vm_obj putstr(lean::vm_obj const & s, lean::vm_obj const &) {
   char *str = *lean::to_raw_ptr<char*>(s);
   std::cout << str;
   std::cout << "------------------" << std::endl;
   return lean::mk_vm_simple(0);
}

}
