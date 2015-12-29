#![feature(link_args)]
#![link_args = "-flat_namespace -undefined suppress"]

#[macro_use]
extern crate ruster_unsafe;
use ruster_unsafe::*;
use std::mem::uninitialized;

/// Create NIF module data and init function.
nif_init!(b"Elixir.RustNif\0", Some(load), None, None, None,
          nif!(b"do_cool_stuff\0", 1, do_cool_stuff)
          );

extern "C" fn load(_env: *mut ErlNifEnv, _priv_data: *mut *mut c_void, _load_info: ERL_NIF_TERM)-> c_int { 0 }

/// Add two integers. `native_add(A,B) -> A+B.`
extern "C" fn do_cool_stuff(env: *mut ErlNifEnv,
                            _argc: c_int,
                            args: *const ERL_NIF_TERM) -> ERL_NIF_TERM {
    let mut vec: Vec<i32> = Vec::new();

    unsafe {
        let mut tail: ERL_NIF_TERM = *args;
        let mut head: ERL_NIF_TERM = uninitialized();

        let mut list_length: u32 = uninitialized();

        if 1 != enif_get_list_length(env, tail, &mut list_length) || list_length == 0 {
            return enif_make_badarg(env);
        }


        while 0 != enif_get_list_cell(env, tail, &mut head, &mut tail) {
            let mut var: i32 = uninitialized();
            if 1 != enif_get_int(env, head, &mut var) {
                return enif_make_badarg(env);
            }
            vec.push(var);
        }
    }

    let mut largest: i32 = vec.pop().unwrap();
    let mut count: i32 = 1;

    for item in vec.iter() {
        let num = *item;
        if num > largest {
            largest = num;
            count = 1;
        } else if num == largest {
            count += 1;
        }
    }

    let mut v: Vec<ERL_NIF_TERM> = Vec::new();

    unsafe {
        let lar = enif_make_int(env, largest);
        for _ in 0..count {
            v.push(lar);
        }
    }

    let g = v.into_boxed_slice();

    unsafe {
        enif_make_list_from_array(env, g.as_ptr(), g.len() as u32)
    }
}
