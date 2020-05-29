#+-----------------------------------------------------------------------------+
#| This code corresponds to the the paper "Efficient 4-way Vectorizations of   |
#| the Montgomery Ladder" authored by   			       	       |
#| Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and            |
#| Palash Sarkar, Indian Statistical Institute, Kolkata, India.	               |
#+-----------------------------------------------------------------------------+
#| Copyright (c) 2020, Kaushik Nath, Palash Sarkar.                            |
#|                                                                             |
#| Permission to use this code is granted.                          	       |
#|                                                                             |
#| Redistribution and use in source and binary forms, with or without          |
#| modification, are permitted provided that the following conditions are      |
#| met:                                                                        |
#|                                                                             |
#| * Redistributions of source code must retain the above copyright notice,    |
#|   this list of conditions and the following disclaimer.                     |
#|                                                                             |
#| * Redistributions in binary form must reproduce the above copyright         |
#|   notice, this list of conditions and the following disclaimer in the       |
#|   documentation and/or other materials provided with the distribution.      |
#|                                                                             |
#| * The names of the contributors may not be used to endorse or promote       |
#|   products derived from this software without specific prior written        |
#|   permission.                                                               |
#+-----------------------------------------------------------------------------+
#| THIS SOFTWARE IS PROVIDED BY THE AUTHORS ""AS IS"" AND ANY EXPRESS OR       |
#| IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES   |
#| OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.     |
#| IN NO EVENT SHALL THE CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,      |
#| INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT    |
#| NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   |
#| DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY       |
#| THEORY LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING |
#| NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,| 
#| EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                          |
#+-----------------------------------------------------------------------------+
#

INCDRS = -I../include/

SRCFLS = ../source/curve448_const.s 		\
	 ../source/curve448_mladder.s		\
	 ../source/curve448_mladder_base.s	\
	 ../source/gf_p4482241_mulx.s 		\
	 ../source/gf_p4482241_nsqrx.s 		\
	 ../source/gf_p4482241_mul.s 		\
	 ../source/gf_p4482241_nsqr.s 		\
	 ../source/gf_p4482241_makeunique.s	\
	 ../source/gf_p4482241_pack.c		\
	 ../source/gf_p4482241_inv.c 		\
	 ../source/curve448_scalarmult.c	\
	  ./curve448_test.c
         
OBJFLS = ../source/curve448_const.o 		\
	 ../source/curve448_mladder.o		\
	 ../source/curve448_mladder_base.o	\
	 ../source/gf_p4482241_mulx.o 		\
	 ../source/gf_p4482241_nsqrx.o 		\
	 ../source/gf_p4482241_mul.o 		\
	 ../source/gf_p4482241_nsqr.o 		\
	 ../source/gf_p4482241_makeunique.o	\
	 ../source/gf_p4482241_pack.o		\
	 ../source/gf_p4482241_inv.o 		\
	 ../source/curve448_scalarmult.o	\
	  ./curve448_test.o

EXE    = curve448_test

#CFLAGS = -march=haswell -mtune=haswell -mavx2 -m64 -O3 -funroll-loops -fomit-frame-pointer
CFLAGS = -march=skylake -mtune=skylake -mavx2 -m64 -O3 -funroll-loops -fomit-frame-pointer

CC     = gcc
LL     = gcc

$(EXE): $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) -lm -no-pie

.c.o:
	$(CC) $(INCDRS) $(CFLAGS) -o $@ -c $<

clean:
	-rm $(EXE)
	-rm $(OBJFLS)
