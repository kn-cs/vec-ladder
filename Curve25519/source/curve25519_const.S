/*
+-----------------------------------------------------------------------------+
| This code corresponds to the the paper "Efficient 4-way Vectorizations of   |
| the Montgomery Ladder" authored by   			       	       	      |
| Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and            |
| Palash Sarkar, Indian Statistical Institute, Kolkata, India.	              |
+-----------------------------------------------------------------------------+
| Copyright (c) 2020, Kaushik Nath and Palash Sarkar.                         |
|                                                                             |
| Permission to use this code is granted.                          	      |
|                                                                             |
| Redistribution and use in source and binary forms, with or without          |
| modification, are permitted provided that the following conditions are      |
| met:                                                                        |
|                                                                             |
| * Redistributions of source code must retain the above copyright notice,    |
|   this list of conditions and the following disclaimer.                     |
|                                                                             |
| * Redistributions in binary form must reproduce the above copyright         |
|   notice, this list of conditions and the following disclaimer in the       |
|   documentation and/or other materials provided with the distribution.      |
|                                                                             |
| * The names of the contributors may not be used to endorse or promote       |
|   products derived from this software without specific prior written        |
|   permission.                                                               |
+-----------------------------------------------------------------------------+
| THIS SOFTWARE IS PROVIDED BY THE AUTHORS ""AS IS"" AND ANY EXPRESS OR       |
| IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES   |
| OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.     |
| IN NO EVENT SHALL THE CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,      |
| INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT    |
| NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   |
| DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY       |
| THEORY LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING |
| NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,| 
| EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                          |
+-----------------------------------------------------------------------------+
*/

.data

.globl hh1_p1
.globl hh1_p2
.globl h2h_p1
.globl h2h_p2
.globl hh1_xor
.globl h2h_xor
.globl swap_c
.globl swap_mask
.globl h2h_mask
.globl vec19
.globl vec38
.globl vecmask25
.globl vecmask26
.globl vecmask32
.globl a24
.globl mask51
.globl mask63
.globl zero

.p2align 5

hh1_p1		: .long 0x0,0x0,0x7FFFFDB,0x3FFFFFF,0x7FFFFDB,0x3FFFFFF,0x0,0x0
hh1_p2 		: .long 0x0,0x0,0x7FFFFFF,0x3FFFFFF,0x7FFFFFF,0x3FFFFFF,0x0,0x0
h2h_p1 		: .long 0x0,0x0,0x7FFFFDB,0x3FFFFFF,0x0,0x0,0x7FFFFDB,0x3FFFFFF
h2h_p2 		: .long 0x0,0x0,0x7FFFFFF,0x3FFFFFF,0x0,0x0,0x7FFFFFF,0x3FFFFFF
hh1_xor	 	: .long 0,0,-1,-1,-1,-1,0,0
h2h_xor	 	: .long 0,0,-1,-1,0,0,-1,-1
swap_c	 	: .long 0,1,2,3,4,5,6,7
swap_mask	: .long 7,7,7,7,7,7,7,7
h2h_mask	: .quad 0,-1,-1,-1
vec19 	 	: .quad 19,19,19,19
vec38 	 	: .quad 38,38,38,38
vecmask25	: .quad 0x1FFFFFF,0x1FFFFFF,0x1FFFFFF,0x1FFFFFF
vecmask26	: .quad 0x3FFFFFF,0x3FFFFFF,0x3FFFFFF,0x3FFFFFF
vecmask32	: .quad 0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF
a24	 	: .quad 0,121666,0,0
mask51		: .quad 0x7FFFFFFFFFFFF
mask63	 	: .quad 0x7FFFFFFFFFFFFFFF
zero	 	: .quad 0

