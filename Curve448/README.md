# Implementation of shared secret computation for Curve448.

# Implementation name	:  intel64-simd4
# Timings		:  Skylake - 361621, Haswell - 441332

This implementation corresponds to the paper "Efficient 4-way Vectorizations of the Montgomery Ladder" authored by

    Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and   
    Palash Sarkar, Indian Statistical Institute, Kolkata, India.

There are three directories, namely "include", "source", and "test" in the software package. 
The description of the files in each directory are listed below:

include/basic_types.h  			:  Defines the basic datatypes.

include/gf_p4482241_type.h    		:  Defines the types of field elements in GF[2^(448)-2^(224)-1].

include/gf_p4482241_arith.h    		:  Declares the prototypes of field arithmetic functions in GF[2^(448)-2^(224)-1].

include/gf_p4482241_pack.h    		:  Declares the prototypes of functions for byte to 64-bit integer conversion of field elements and vice versa.

include/curve448.h    			:  Declares the prototypes of functions for the vectorized Montgomery ladder and shared secret computation.

include/measure.h   			:  Defines the timing function for measuring median cpu-cycles.

source/curve448_shared_secret.c		:  Defines the functions of vectorized Montgomery ladder and shared secret computation.

source/curve448_mladder.S		:  Defines the assembly source of the vectorized Montgomery ladder.

source/gf_p4482241_mulx.S		:  Defines the assembly source of field multiplication using mulx/adcx/adox instructions.

source/gf_p4482241_nsqrx.S		:  Defines the assembly source of n-times feedback field squaring using mulx/adcx/adox instructions.

source/gf_p4482241_mul.S		:  Defines the assembly source of field multiplication using mul/add/adc instructions.

source/gf_p4482241_nsqr.S		:  Defines the assembly source of n-times feedback field squaring mul/add/adc instructions.

source/gf_p4482241_makeunique_sub.S	:  Defines the subtraction assembly source required to get unique representation of field-elements in GF[2^(448)-2^(224)-1].

source/gf_p4482241_consts.S		:  Defines the assembly constants.

source/gf_p4482241_inv.c		:  Defines the functions for field inversion using FLT.

source/gf_p4482241_pack.c		:  Defines functions for byte to 64-bit integer conversion of field elements and vice versa.

source/gf_p4482241_makeunique.c		:  Defines the function to get unique representation of field-elements in GF[2^(448)-2^(224)-1].

test/curve448_test.c			:  Defines the test function for shared secret computation.

test/curve448.mak			:  Defines the makefile.

  
For compilation, one needs to use the command "make -f curve448.mak", and execute the generated executable file named "curve448_test".

