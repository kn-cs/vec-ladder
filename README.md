## Efficient 4-way Vectorizations of the Montgomery Ladder

This is the source code repository of the work [Efficient 4-way Vectorizations of the Montgomery Ladder](https://eprint.iacr.org/2020/378.pdf), authored by [Kaushik Nath](kaushikn_r@isical.ac.in) & [Palash Sarkar](palash@isical.ac.in) of [Indian Statistical Institute, Kolkata, India](https://www.isical.ac.in).
This work focuses on vectorizing the Montgomery ladder on Mongomery curves by handling 4 field operations at a time. All the implementations of Montgomery ladder are developed in assembly language targeting the modern Intel architectures which are enabled with the AVX2 instruction set.

To report a bug or make a comment regarding the implementations please drop a mail to: [Kaushik Nath](kaushikn_r@isical.ac.in).

---

### Compilation and execution of programs 
    
* Please compile the ```makefile``` in the **test** directory and execute the generated executable file. 
* One can change the architecture accordingly in the makefile before compilation. Default provided is ```Skylake```.
---

### Overview of various implementations in the repository

#### Curve25519:

* **intel64-avx2-9limb-4x1**: 9-limb assembly implementation of **shared secret computation** and **key generation** using Algorithms 8 and 9 of [Efficient 4-way Vectorizations of the Montgomery Ladder](https://eprint.iacr.org/2020/378.pdf).
* **intel64-avx2-10limb-4x1**: 10-limb assembly implementation of **shared secret computation** and **key generation** using Algorithms 8 and 9 of [Efficient 4-way Vectorizations of the Montgomery Ladder](https://eprint.iacr.org/2020/378.pdf).
* **intel64-avx2-9limb-4x1-hey**: 9-limb assembly implementation of **shared secret computation** using the vectorization strategy of [Fast 4 way vectorized ladder for the complete set of Montgomery curves](https://eprint.iacr.org/2020/388.pdf). 
* **intel64-avx2-10limb-4x1-hey**: 10-limb assembly implementation of **shared secret computation** using the vectorization strategy of [Fast 4 way vectorized ladder for the complete set of Montgomery curves](https://eprint.iacr.org/2020/388.pdf).

    
#### Curve448:

* **intel64-avx2-16limb-4x1**  : 16-limb assembly implementation of **shared secret computation** and **key generation** using Algorithms 8 and 9 of [Efficient 4-way Vectorizations of the Montgomery Ladder](https://eprint.iacr.org/2020/378.pdf).
* **intel64-avx2-16limb-4x1-hey**  : 16-limb assembly implementation of **shared secret computation** using the vectorization strategy of [Fast 4 way vectorized ladder for the complete set of Montgomery curves](https://eprint.iacr.org/2020/388.pdf).

---    
