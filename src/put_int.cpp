#include <iostream>
#include "util/numerics/mpz.h"
#include "library/vm/vm_io.h"
#include "library/vm/vm.h"
#include "library/vm/vm_ptr.h"
#include "init/init.h"

// static lean::environment * g_env = nullptr;

lean::vm_obj put_int(lean::vm_obj const & iptr, lean::vm_obj const &) {
    int i = *lean::get_vm_ptr<int>(iptr);
    std::cout << i;
    return lean::mk_vm_simple(0);
}

lean::vm_obj puts(lean::vm_obj const & s, lean::vm_obj const &) {
    char *str = *lean::get_vm_ptr<char*>(s);
    int i = 0;
    while (i != '\0') {
        std::cout << i << ":" << str[i];
    }
    return lean::mk_vm_simple(0);
}

