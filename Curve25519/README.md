# Implementation of shared secret computation for Curve25519.

# Implementation name	:  intel64-simd4
# Timings		:  Skylake - 95437, Haswell - 123899

This implementation corresponds to the paper "Efficient 4-way Vectorizations of the Montgomery Ladder" authored by

    Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and   
    Palash Sarkar, Indian Statistical Institute, Kolkata, India.

There are three directories, namely "include", "source", and "test" in the package. 
The description of the files in each directory are listed below:

include/basic_types.h  			:  Defines the basic datatypes.

include/gf_p25519_type.h    		:  Defines the types of field elements in GF[2^(255)-19].

include/gf_p25519_arith.h    		:  Declares the prototypes of field arithmetic functions in GF[2^(255)-19].

include/gf_p25519_pack.h    		:  Declares the prototypes of functions for byte to 64-bit integer conversion of field elements and vice versa.

include/curve25519.h    		:  Declares the prototypes of functions for the vectorized Montgomery ladder and shared secret computation.

include/measure.h   			:  Defines the timing function for measuring median cpu-cycles.

source/curve25519_shared_secret.c	:  Defines the functions of vectorized Montgomery ladder and shared secret computation.

source/curve25519_mladder.S		:  Defines the assembly source of the vectorized Montgomery ladder.

source/gf_p25519_mulx.S			:  Defines the assembly source of field multiplication using mulx/adcx/adox instructions.

source/gf_p25519_nsqrx.S		:  Defines the assembly source of n-times feedback field squaring using mulx/adcx/adox instructions.

source/gf_p25519_mul.S			:  Defines the assembly source of field multiplication using mul/add/adc instructions.

source/gf_p25519_nsqr.S			:  Defines the assembly source of n-times feedback field squaring mul/add/adc instructions.

source/gf_p25519_consts.S		:  Defines the assembly constants.

source/gf_p25519_inv.c			:  Defines the functions for field inversion using FLT.

source/gf_p25519_pack.c			:  Defines functions for byte to 64-bit integer conversion of field elements and vice versa.

source/gf_p25519_makeunique.c		:  Defines the function to get unique representation of field-elements in GF[2^(255)-19].

test/curve25519_test.c			:  Defines the test function for shared secret computation.

test/curve25519.mak			:  Defines the makefile.

 
For compilation, one needs to use the command "make -f curve25519.mak", and execute the generated executable file named "curve25519_test".

