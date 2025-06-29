/*
+-----------------------------------------------------------------------------+
| This code corresponds to the the paper "Efficient 4-way Vectorizations of   |
| the Montgomery Ladder" authored by   			       	       	      |
| Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and            |
| Palash Sarkar, Indian Statistical Institute, Kolkata, India.	              |
+-----------------------------------------------------------------------------+
| Copyright (c) 2020, Kaushik Nath.                                           |
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

.globl hh_p1
.globl hh_p2
.globl hh_xor
.globl sub_p1
.globl sub_p2
.globl swap_c
.globl swap_mask
.globl vecmask28d
.globl vecmask28
.globl vecmask32
.globl mask56
.globl p012456
.globl p3

.p2align 5

hh_p1 		: .long 0x0,0x0,0x1FFFFFFF,0x1FFFFFFD,0x0,0x0,0x1FFFFFFF,0x1FFFFFFD
hh_p2 		: .long 0x0,0x0,0x1FFFFFFF,0x1FFFFFFF,0x0,0x0,0x1FFFFFFF,0x1FFFFFFF
hh_xor	 	: .long 0,0,-1,-1,0,0,-1,-1
sub_p1		: .long 0x1FFFFFFE,0x1FFFFFFC,0x0,0x0,0x0,0x0,0x0,0x0
sub_p2		: .long 0x1FFFFFFE,0x1FFFFFFE,0x0,0x0,0x0,0x0,0x0,0x0
swap_c	 	: .long 0,1,2,3,4,5,6,7
swap_mask 	: .long 7,7,7,7,7,7,7,7
vecmask28d	: .long 0xFFFFFFF,0xFFFFFFF,0xFFFFFFF,0xFFFFFFF,0xFFFFFFF,0xFFFFFFF,0xFFFFFFF,0xFFFFFFF
vecmask28	: .quad 0xFFFFFFF,0xFFFFFFF,0xFFFFFFF,0xFFFFFFF
vecmask32	: .quad 0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF
mask56		: .quad 0xFFFFFFFFFFFFFF
p012456		: .quad 0xFFFFFFFFFFFFFFFF
p3		: .quad 0xFFFFFFFEFFFFFFFF
