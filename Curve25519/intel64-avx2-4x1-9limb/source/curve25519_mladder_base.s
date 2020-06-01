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

.p2align 5
.globl curve25519_mladder_base
curve25519_mladder_base:

movq 	  %rsp,%r11
andq 	  $-32,%rsp
subq 	  $1536,%rsp

movq 	  %r11,0(%rsp)
movq 	  %r12,8(%rsp)
movq 	  %r13,16(%rsp)
movq 	  %r14,24(%rsp)
movq 	  %r15,32(%rsp)
movq 	  %rbx,40(%rsp)
movq 	  %rbp,48(%rsp)

// load <X2,Z2,X3,Z3>
vmovdqa   0(%rdi),  %ymm10
vmovdqa   32(%rdi), %ymm11
vmovdqa   64(%rdi), %ymm12
vmovdqa   96(%rdi), %ymm13
vmovdqa   128(%rdi),%ymm0
vmovdqa   160(%rdi),%ymm1
vmovdqa   192(%rdi),%ymm2
vmovdqa   224(%rdi),%ymm3
vmovdqa   256(%rdi),%ymm4

// <X2',Z2',X3',Z3'> ← Pack-D2N(<X2,Z2,X3,Z3>)
vpsllq    $32,%ymm0,%ymm0
vpor      %ymm0,%ymm10,%ymm10
vpsllq    $32,%ymm1,%ymm1
vpor      %ymm1,%ymm11,%ymm11
vpsllq    $32,%ymm2,%ymm2
vpor      %ymm2,%ymm12,%ymm12
vpsllq    $32,%ymm3,%ymm3
vpor      %ymm3,%ymm13,%ymm13

movq      $31,%r15
movq	  $6,%rcx

movb      $0,%r8b
movq      %rdx,%rax

.L1:
addq      %r15,%rax
movb      0(%rax),%r14b
movq      %rdx,%rax

.L2:
movb	  %r14b,%bl
shrb      %cl,%bl
andb      $1,%bl
movb      %bl,%r9b
xorb      %r8b,%bl
movb      %r9b,%r8b

// <X2',Z2',X3',Z3'> ← Dense-Swap(<X2',Z2',X3',Z3'>,b)
movzbl    %bl,%ebx
imul	  $4,%ebx,%ebx
movl      %ebx,56(%rsp)
vpbroadcastd 56(%rsp),%ymm7
vpaddd	  swap_c,%ymm7,%ymm7
vpand     swap_mask,%ymm7,%ymm7

vpermd	  %ymm10,%ymm7,%ymm10
vpermd	  %ymm11,%ymm7,%ymm11
vpermd	  %ymm12,%ymm7,%ymm12
vpermd	  %ymm13,%ymm7,%ymm13
vpermd	  %ymm4,%ymm7,%ymm4

// <T1',T2',T4',T3'> ← Dense-H-H1(<X2',Z2',X3',Z3'>)
vpshufd	  $68,%ymm10,%ymm5
vpshufd	  $238,%ymm10,%ymm6
vpaddd    hh1_p1,%ymm5,%ymm5
vpxor     hh1_xor1,%ymm6,%ymm6
vpaddd    %ymm5,%ymm6,%ymm10

vpshufd	  $68,%ymm11,%ymm5
vpshufd	  $238,%ymm11,%ymm6
vpaddd    hh1_p2,%ymm5,%ymm5
vpxor     hh1_xor1,%ymm6,%ymm6
vpaddd    %ymm5,%ymm6,%ymm11

vpshufd	  $68,%ymm12,%ymm5
vpshufd	  $238,%ymm12,%ymm6
vpaddd    hh1_p2,%ymm5,%ymm5
vpxor     hh1_xor1,%ymm6,%ymm6
vpaddd    %ymm5,%ymm6,%ymm12

vpshufd	  $68,%ymm13,%ymm5
vpshufd	  $238,%ymm13,%ymm6
vpaddd    hh1_p2,%ymm5,%ymm5
vpxor     hh1_xor1,%ymm6,%ymm6
vpaddd    %ymm5,%ymm6,%ymm13

vpshufd	  $68,%ymm4,%ymm5
vpshufd	  $238,%ymm4,%ymm6
vpaddd    hh1_p3,%ymm5,%ymm5
vpxor     hh1_xor2,%ymm6,%ymm6
vpaddd    %ymm5,%ymm6,%ymm4

vpsrld    $29,%ymm10,%ymm15
vpaddd    %ymm15,%ymm11,%ymm11
vpand     vecmask29d,%ymm10,%ymm10

vpsrld    $29,%ymm11,%ymm15
vpaddd    %ymm15,%ymm12,%ymm12
vpand     vecmask29d,%ymm11,%ymm11

vpsrld    $29,%ymm12,%ymm15
vpaddd    %ymm15,%ymm13,%ymm13
vpand     vecmask29d,%ymm12,%ymm12

vpsrld    $29,%ymm13,%ymm15
vpsllq    $32,%ymm15,%ymm15
vpaddd    %ymm15,%ymm10,%ymm10
vpsrlq    $61,%ymm13,%ymm15
vpaddd    %ymm15,%ymm4,%ymm4
vpand     vecmask29d,%ymm13,%ymm13

vpsrlq    $23,%ymm4,%ymm15
vpmuludq  vec19,%ymm15,%ymm15
vpaddd    %ymm15,%ymm10,%ymm10
vpand     vecmask23,%ymm4,%ymm9

// <T1,T2,T4,T3> ← Pack-N2D(<T1',T2',T4',T3'>)
vpsrlq    $32,%ymm10,%ymm5
vpsrlq    $32,%ymm11,%ymm6
vpsrlq    $32,%ymm12,%ymm7
vpsrlq    $32,%ymm13,%ymm8

vmovdqa   %ymm10,192(%rsp)
vmovdqa   %ymm11,224(%rsp)
vmovdqa   %ymm12,256(%rsp)
vmovdqa   %ymm13,288(%rsp)

// <T1',T2',T1',T2'> ← Dense-Dup(<T1',T2',T4',T3'>)
vpermq	  $68,%ymm10,%ymm10
vpermq	  $68,%ymm11,%ymm11
vpermq	  $68,%ymm12,%ymm12
vpermq	  $68,%ymm13,%ymm13
vpermq	  $68,%ymm9,%ymm4

// <T1,T2,T1,T2> ← Pack-D2N(<T1',T2',T1',T2'>)
vpsrlq    $32,%ymm10,%ymm0
vpsrlq    $32,%ymm11,%ymm1
vpsrlq    $32,%ymm12,%ymm2
vpsrlq    $32,%ymm13,%ymm3

// <T5,T6,T7,T8> ← Mul(<T1,T2,T4,T3>,<T1,T2,T1,T2>)
vpmuludq  %ymm5,%ymm0,%ymm15
vmovdqa   %ymm15,480(%rsp)

vpmuludq  %ymm6,%ymm0,%ymm15
vpmuludq  %ymm5,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,512(%rsp)

vpmuludq  %ymm7,%ymm0,%ymm15
vpmuludq  %ymm6,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,544(%rsp)

vpmuludq  %ymm8,%ymm0,%ymm15
vpmuludq  %ymm7,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,576(%rsp)

vpmuludq  %ymm9,%ymm0,%ymm15
vpmuludq  %ymm8,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,608(%rsp)

vpmuludq  %ymm9,%ymm1,%ymm15
vpmuludq  %ymm8,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,640(%rsp)

vpmuludq  %ymm9,%ymm2,%ymm15
vpmuludq  %ymm8,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,672(%rsp)

vpmuludq  %ymm9,%ymm3,%ymm15
vpmuludq  %ymm8,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,704(%rsp)

vpmuludq  %ymm9,%ymm4,%ymm15
vmovdqa   %ymm15,736(%rsp)

vpaddq    %ymm10,%ymm0,%ymm0
vpaddq    %ymm11,%ymm1,%ymm1
vpaddq    %ymm12,%ymm2,%ymm2
vpaddq    %ymm13,%ymm3,%ymm3
vpaddq    192(%rsp),%ymm5,%ymm5
vpaddq    224(%rsp),%ymm6,%ymm6
vpaddq    256(%rsp),%ymm7,%ymm7
vpaddq    288(%rsp),%ymm8,%ymm8

vpmuludq  192(%rsp),%ymm10,%ymm15
vmovdqa   %ymm15,768(%rsp)
vpaddq    480(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,992(%rsp)

vpmuludq  224(%rsp),%ymm10,%ymm15
vpmuludq  192(%rsp),%ymm11,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,800(%rsp)
vpaddq    512(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1024(%rsp)

vpmuludq  256(%rsp),%ymm10,%ymm15
vpmuludq  224(%rsp),%ymm11,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  192(%rsp),%ymm12,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,832(%rsp)
vpaddq    544(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1056(%rsp)

vpmuludq  288(%rsp),%ymm10,%ymm15
vpmuludq  256(%rsp),%ymm11,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  224(%rsp),%ymm12,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  192(%rsp),%ymm13,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,864(%rsp)
vpaddq    576(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1088(%rsp)

vpmuludq  288(%rsp),%ymm11,%ymm15
vpmuludq  256(%rsp),%ymm12,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  224(%rsp),%ymm13,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,896(%rsp)
vpaddq    608(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1120(%rsp)

vpmuludq  288(%rsp),%ymm12,%ymm15
vpmuludq  256(%rsp),%ymm13,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,928(%rsp)
vpaddq    640(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1152(%rsp)

vpmuludq  288(%rsp),%ymm13,%ymm15
vmovdqa   %ymm15,960(%rsp)
vpaddq    672(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1184(%rsp)

vpmuludq  %ymm5,%ymm0,%ymm15
vmovdqa   %ymm15,1216(%rsp)

vpmuludq  %ymm6,%ymm0,%ymm15
vpmuludq  %ymm5,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm10

vpmuludq  %ymm7,%ymm0,%ymm15
vpmuludq  %ymm6,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm11

vpmuludq  %ymm8,%ymm0,%ymm15
vpmuludq  %ymm7,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm12

vpmuludq  %ymm9,%ymm0,%ymm15
vpmuludq  %ymm8,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm13

vpmuludq  %ymm9,%ymm1,%ymm15
vpmuludq  %ymm8,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm0

vpmuludq  %ymm9,%ymm2,%ymm15
vpmuludq  %ymm8,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm1

vpmuludq  %ymm9,%ymm3,%ymm15
vpmuludq  %ymm8,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm2

vpmuludq  %ymm9,%ymm4,%ymm3

vmovdqa   1216(%rsp),%ymm9

vpsubq    992(%rsp),%ymm9,%ymm9
vpaddq    896(%rsp),%ymm9,%ymm9
vpsubq    1024(%rsp),%ymm10,%ymm10
vpaddq    928(%rsp),%ymm10,%ymm10
vpsubq    1056(%rsp),%ymm11,%ymm11
vpaddq    960(%rsp),%ymm11,%ymm11
vpsubq    1088(%rsp),%ymm12,%ymm12
vpsubq    1120(%rsp),%ymm13,%ymm13
vpaddq    480(%rsp),%ymm13,%ymm13
vpsubq    1152(%rsp),%ymm0,%ymm0
vpaddq    512(%rsp),%ymm0,%ymm0
vpsubq    1184(%rsp),%ymm1,%ymm1
vpaddq    544(%rsp),%ymm1,%ymm1
vpsubq    704(%rsp),%ymm2,%ymm2
vpaddq    576(%rsp),%ymm2,%ymm2
vpsubq    736(%rsp),%ymm3,%ymm3
vpaddq    608(%rsp),%ymm3,%ymm3

vpsrlq    $29,%ymm0,%ymm14
vpaddq    %ymm14,%ymm1,%ymm1
vpand     vecmask29,%ymm0,%ymm0
vpmuludq  vec1216,%ymm0,%ymm0
vpaddq    768(%rsp),%ymm0,%ymm0

vpsrlq    $29,%ymm1,%ymm14
vpaddq    %ymm14,%ymm2,%ymm2
vpand     vecmask29,%ymm1,%ymm1
vpmuludq  vec1216,%ymm1,%ymm1
vpaddq    800(%rsp),%ymm1,%ymm1

vpsrlq    $29,%ymm2,%ymm14
vpaddq    %ymm14,%ymm3,%ymm3
vpand     vecmask29,%ymm2,%ymm2
vpmuludq  vec1216,%ymm2,%ymm2
vpaddq    832(%rsp),%ymm2,%ymm2

vpsrlq    $29,%ymm3,%ymm14
vpaddq    640(%rsp),%ymm14,%ymm14
vpand     vecmask29,%ymm3,%ymm3
vpmuludq  vec1216,%ymm3,%ymm3
vpaddq    864(%rsp),%ymm3,%ymm3

vpsrlq    $29,%ymm14,%ymm15
vpaddq    672(%rsp),%ymm15,%ymm15
vpand     vecmask29,%ymm14,%ymm4
vpmuludq  vec1216,%ymm4,%ymm4
vpaddq    %ymm9,%ymm4,%ymm4

vpsrlq    $29,%ymm15,%ymm14
vpaddq    704(%rsp),%ymm14,%ymm14
vpand     vecmask29,%ymm15,%ymm5
vpmuludq  vec1216,%ymm5,%ymm5
vpaddq    %ymm10,%ymm5,%ymm5

vpsrlq    $29,%ymm14,%ymm15
vpaddq    736(%rsp),%ymm15,%ymm15
vpand     vecmask29,%ymm14,%ymm6
vpmuludq  vec1216,%ymm6,%ymm6
vpaddq    %ymm11,%ymm6,%ymm6

vpsrlq    $29,%ymm15,%ymm8
vpand     vecmask29,%ymm15,%ymm7

vpmuludq  vec1216,%ymm7,%ymm7
vpaddq    %ymm12,%ymm7,%ymm7
vpmuludq  vec1216,%ymm8,%ymm8
vpaddq    %ymm13,%ymm8,%ymm8

vpsrlq    $29,%ymm4,%ymm10
vpaddq    %ymm10,%ymm5,%ymm5
vpand     vecmask29,%ymm4,%ymm4

vpsrlq    $29,%ymm0,%ymm10
vpaddq    %ymm10,%ymm1,%ymm1
vpand     vecmask29,%ymm0,%ymm0

vpsrlq    $29,%ymm5,%ymm10
vpaddq    %ymm10,%ymm6,%ymm6
vpand     vecmask29,%ymm5,%ymm5

vpsrlq    $29,%ymm1,%ymm10
vpaddq    %ymm10,%ymm2,%ymm2
vpand     vecmask29,%ymm1,%ymm1

vpsrlq    $29,%ymm6,%ymm10
vpaddq    %ymm10,%ymm7,%ymm7
vpand     vecmask29,%ymm6,%ymm6

vpsrlq    $29,%ymm2,%ymm10
vpaddq    %ymm10,%ymm3,%ymm3
vpand     vecmask29,%ymm2,%ymm2

vpsrlq    $29,%ymm7,%ymm10
vpaddq    %ymm10,%ymm8,%ymm8
vpand     vecmask29,%ymm7,%ymm7

vpsrlq    $29,%ymm3,%ymm10
vpaddq    %ymm10,%ymm4,%ymm4
vpand     vecmask29,%ymm3,%ymm3

vpsrlq    $23,%ymm8,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpaddq    %ymm10,%ymm10,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpsllq    $3,%ymm10,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpand     vecmask23,%ymm8,%ymm8

vpsrlq    $29,%ymm4,%ymm10
vpaddq    %ymm10,%ymm5,%ymm5
vpand     vecmask29,%ymm4,%ymm4

vpsrlq    $29,%ymm0,%ymm10
vpaddq    %ymm10,%ymm1,%ymm1
vpand     vecmask29,%ymm0,%ymm0

vmovdqa   %ymm0,1248(%rsp)
vmovdqa   %ymm1,1280(%rsp)
vmovdqa   %ymm2,1312(%rsp)
vmovdqa   %ymm3,1344(%rsp)
vmovdqa   %ymm4,1376(%rsp)
vmovdqa   %ymm5,1408(%rsp)
vmovdqa   %ymm6,1440(%rsp)
vmovdqa   %ymm7,1472(%rsp)
vmovdqa   %ymm8,1504(%rsp)

// <T5',T6',T7',T8'> ← Pack-N2D(<T5,T6,T7,T8>)
vpsllq    $32,%ymm4,%ymm4
vpor      %ymm4,%ymm0,%ymm0
vpsllq    $32,%ymm5,%ymm5
vpor      %ymm5,%ymm1,%ymm1
vpsllq    $32,%ymm6,%ymm6
vpor      %ymm6,%ymm2,%ymm2
vpsllq    $32,%ymm7,%ymm7
vpor      %ymm7,%ymm3,%ymm3

// <T9',T10',T11',T12'> ← Dense-H2-H(<T5',T6',T7',T8'>)
vpshufd	  $68,%ymm0,%ymm9
vpand     h2h_mask,%ymm9,%ymm9
vpshufd	  $238,%ymm0,%ymm10
vpaddd    h2h_p1,%ymm9,%ymm9
vpxor     h2h_xor1,%ymm10,%ymm10
vpaddd    %ymm9,%ymm10,%ymm0

vpshufd	  $68,%ymm1,%ymm9
vpand     h2h_mask,%ymm9,%ymm9
vpshufd	  $238,%ymm1,%ymm10
vpaddd    h2h_p2,%ymm9,%ymm9
vpxor     h2h_xor1,%ymm10,%ymm10
vpaddd    %ymm9,%ymm10,%ymm1

vpshufd	  $68,%ymm2,%ymm9
vpand     h2h_mask,%ymm9,%ymm9
vpshufd	  $238,%ymm2,%ymm10
vpaddd    h2h_p2,%ymm9,%ymm9
vpxor     h2h_xor1,%ymm10,%ymm10
vpaddd    %ymm9,%ymm10,%ymm2

vpshufd	  $68,%ymm3,%ymm9
vpand     h2h_mask,%ymm9,%ymm9
vpshufd	  $238,%ymm3,%ymm10
vpaddd    h2h_p2,%ymm9,%ymm9
vpxor     h2h_xor1,%ymm10,%ymm10
vpaddd    %ymm9,%ymm10,%ymm3

vpshufd	  $68,%ymm8,%ymm9
vpand     h2h_mask,%ymm9,%ymm9
vpshufd	  $238,%ymm8,%ymm10
vpaddd    h2h_p3,%ymm9,%ymm9
vpxor     h2h_xor2,%ymm10,%ymm10
vpaddd    %ymm9,%ymm10,%ymm8

vpsrld    $29,%ymm0,%ymm15
vpaddd    %ymm15,%ymm1,%ymm1
vpand     vecmask29d,%ymm0,%ymm0

vpsrld    $29,%ymm1,%ymm15
vpaddd    %ymm15,%ymm2,%ymm2
vpand     vecmask29d,%ymm1,%ymm1

vpsrld    $29,%ymm2,%ymm15
vpaddd    %ymm15,%ymm3,%ymm3
vpand     vecmask29d,%ymm2,%ymm2

vpsrld    $29,%ymm3,%ymm15
vpsllq    $32,%ymm15,%ymm15
vpaddd    %ymm15,%ymm0,%ymm0
vpsrlq    $61,%ymm3,%ymm15
vpaddd    %ymm15,%ymm8,%ymm8
vpand     vecmask29d,%ymm3,%ymm3

vpsrlq    $23,%ymm8,%ymm15
vpmuludq  vec19,%ymm15,%ymm15
vpaddd    %ymm15,%ymm0,%ymm0
vpand     vecmask23,%ymm8,%ymm9

// <T9,T10,T11,T12> ← Pack-D2N(<T9',T10',T11',T12'>)
vmovdqa   %ymm0,192(%rsp)
vpsrlq    $32,%ymm0,%ymm5
vmovdqa   %ymm5,320(%rsp)
vmovdqa   %ymm1,224(%rsp)
vpsrlq    $32,%ymm1,%ymm6
vmovdqa   %ymm6,352(%rsp)
vmovdqa   %ymm2,256(%rsp)
vpsrlq    $32,%ymm2,%ymm7
vmovdqa   %ymm7,384(%rsp)
vmovdqa   %ymm3,288(%rsp)
vpsrlq    $32,%ymm3,%ymm8
vmovdqa   %ymm8,416(%rsp)
vmovdqa   %ymm9,448(%rsp)

// <0,T13,0,0> ← Unreduced-Mulc(<T9,T10,T11,T12>,<0,a24,0,0>)
// <T5,T14,T7,T8> ← Add(<0,T13,0,0>,<T5,T6,T7,T8>)
vpmuludq  a24,%ymm0,%ymm10
vpaddq    1248(%rsp),%ymm10,%ymm10
vpmuludq  a24,%ymm1,%ymm11
vpaddq    1280(%rsp),%ymm11,%ymm11
vpmuludq  a24,%ymm2,%ymm12
vpaddq    1312(%rsp),%ymm12,%ymm12
vpmuludq  a24,%ymm3,%ymm13
vpaddq    1344(%rsp),%ymm13,%ymm13
vpmuludq  a24,%ymm5,%ymm0
vpaddq    1376(%rsp),%ymm0,%ymm0
vpmuludq  a24,%ymm6,%ymm1
vpaddq    1408(%rsp),%ymm1,%ymm1
vpmuludq  a24,%ymm7,%ymm2
vpaddq    1440(%rsp),%ymm2,%ymm2
vpmuludq  a24,%ymm8,%ymm3
vpaddq    1472(%rsp),%ymm3,%ymm3
vpmuludq  a24,%ymm9,%ymm4
vpaddq    1504(%rsp),%ymm4,%ymm4

vpsrlq    $29,%ymm0,%ymm15
vpaddq    %ymm15,%ymm1,%ymm1
vpand     vecmask29,%ymm0,%ymm0

vpsrlq    $29,%ymm10,%ymm15
vpaddq    %ymm15,%ymm11,%ymm11
vpand     vecmask29,%ymm10,%ymm10

vpsrlq    $29,%ymm1,%ymm15
vpaddq    %ymm15,%ymm2,%ymm2
vpand     vecmask29,%ymm1,%ymm1

vpsrlq    $29,%ymm11,%ymm15
vpaddq    %ymm15,%ymm12,%ymm12
vpand     vecmask29,%ymm11,%ymm11

vpsrlq    $29,%ymm2,%ymm15
vpaddq    %ymm15,%ymm3,%ymm3
vpand     vecmask29,%ymm2,%ymm2

vpsrlq    $29,%ymm12,%ymm15
vpaddq    %ymm15,%ymm13,%ymm13
vpand     vecmask29,%ymm12,%ymm12

vpsrlq    $29,%ymm3,%ymm15
vpaddq    %ymm15,%ymm4,%ymm4
vpand     vecmask29,%ymm3,%ymm3

vpsrlq    $29,%ymm13,%ymm15
vpaddq    %ymm15,%ymm0,%ymm0
vpand     vecmask29,%ymm13,%ymm13

vpsrlq    $23,%ymm4,%ymm15
vpmuludq  vec19,%ymm15,%ymm15
vpaddq    %ymm15,%ymm10,%ymm10
vpand     vecmask23,%ymm4,%ymm4

// <T5,T14,T11,T12> ← Blend(<T9,T10,T11,T12>,<T5,T14,T7,T8>,1100)
vpblendd  $240,192(%rsp),%ymm10,%ymm10
vpblendd  $240,224(%rsp),%ymm11,%ymm11
vpblendd  $240,256(%rsp),%ymm12,%ymm12
vpblendd  $240,288(%rsp),%ymm13,%ymm13
vpblendd  $240,%ymm5,%ymm0,%ymm0
vpblendd  $240,%ymm6,%ymm1,%ymm1
vpblendd  $240,%ymm7,%ymm2,%ymm2
vpblendd  $240,%ymm8,%ymm3,%ymm3
vpblendd  $240,%ymm9,%ymm4,%ymm4

// <T15,T16,T17,T18> ← Mul(<T5,T14,T11,T12>,<T9,T10,T11,T12>)
vpmuludq  %ymm5,%ymm0,%ymm15
vmovdqa   %ymm15,480(%rsp)

vpmuludq  %ymm6,%ymm0,%ymm15
vpmuludq  %ymm5,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,512(%rsp)

vpmuludq  %ymm7,%ymm0,%ymm15
vpmuludq  %ymm6,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,544(%rsp)

vpmuludq  %ymm8,%ymm0,%ymm15
vpmuludq  %ymm7,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,576(%rsp)

vpmuludq  %ymm9,%ymm0,%ymm15
vpmuludq  %ymm8,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,608(%rsp)

vpmuludq  %ymm9,%ymm1,%ymm15
vpmuludq  %ymm8,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,640(%rsp)

vpmuludq  %ymm9,%ymm2,%ymm15
vpmuludq  %ymm8,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,672(%rsp)

vpmuludq  %ymm9,%ymm3,%ymm15
vpmuludq  %ymm8,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,704(%rsp)

vpmuludq  %ymm9,%ymm4,%ymm15
vmovdqa   %ymm15,736(%rsp)

vpaddq    %ymm10,%ymm0,%ymm0
vpaddq    %ymm11,%ymm1,%ymm1
vpaddq    %ymm12,%ymm2,%ymm2
vpaddq    %ymm13,%ymm3,%ymm3
vpaddq    192(%rsp),%ymm5,%ymm5
vpaddq    224(%rsp),%ymm6,%ymm6
vpaddq    256(%rsp),%ymm7,%ymm7
vpaddq    288(%rsp),%ymm8,%ymm8

vpmuludq  192(%rsp),%ymm10,%ymm15
vmovdqa   %ymm15,768(%rsp)
vpaddq    480(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,992(%rsp)

vpmuludq  224(%rsp),%ymm10,%ymm15
vpmuludq  192(%rsp),%ymm11,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,800(%rsp)
vpaddq    512(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1024(%rsp)

vpmuludq  256(%rsp),%ymm10,%ymm15
vpmuludq  224(%rsp),%ymm11,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  192(%rsp),%ymm12,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,832(%rsp)
vpaddq    544(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1056(%rsp)

vpmuludq  288(%rsp),%ymm10,%ymm15
vpmuludq  256(%rsp),%ymm11,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  224(%rsp),%ymm12,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  192(%rsp),%ymm13,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,864(%rsp)
vpaddq    576(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1088(%rsp)

vpmuludq  288(%rsp),%ymm11,%ymm15
vpmuludq  256(%rsp),%ymm12,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  224(%rsp),%ymm13,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,896(%rsp)
vpaddq    608(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1120(%rsp)

vpmuludq  288(%rsp),%ymm12,%ymm15
vpmuludq  256(%rsp),%ymm13,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vmovdqa   %ymm15,928(%rsp)
vpaddq    640(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1152(%rsp)

vpmuludq  288(%rsp),%ymm13,%ymm15
vmovdqa   %ymm15,960(%rsp)
vpaddq    672(%rsp),%ymm15,%ymm15
vmovdqa   %ymm15,1184(%rsp)

vpmuludq  %ymm5,%ymm0,%ymm15
vmovdqa   %ymm15,1216(%rsp)

vpmuludq  %ymm6,%ymm0,%ymm15
vpmuludq  %ymm5,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm10

vpmuludq  %ymm7,%ymm0,%ymm15
vpmuludq  %ymm6,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm11

vpmuludq  %ymm8,%ymm0,%ymm15
vpmuludq  %ymm7,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm12

vpmuludq  %ymm9,%ymm0,%ymm15
vpmuludq  %ymm8,%ymm1,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm5,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm13

vpmuludq  %ymm9,%ymm1,%ymm15
vpmuludq  %ymm8,%ymm2,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm6,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm0

vpmuludq  %ymm9,%ymm2,%ymm15
vpmuludq  %ymm8,%ymm3,%ymm14
vpaddq    %ymm14,%ymm15,%ymm15
vpmuludq  %ymm7,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm1

vpmuludq  %ymm9,%ymm3,%ymm15
vpmuludq  %ymm8,%ymm4,%ymm14
vpaddq    %ymm14,%ymm15,%ymm2

vpmuludq  %ymm9,%ymm4,%ymm3

vmovdqa   1216(%rsp),%ymm9

vpsubq    992(%rsp),%ymm9,%ymm9
vpaddq    896(%rsp),%ymm9,%ymm9
vpsubq    1024(%rsp),%ymm10,%ymm10
vpaddq    928(%rsp),%ymm10,%ymm10
vpsubq    1056(%rsp),%ymm11,%ymm11
vpaddq    960(%rsp),%ymm11,%ymm11
vpsubq    1088(%rsp),%ymm12,%ymm12
vpsubq    1120(%rsp),%ymm13,%ymm13
vpaddq    480(%rsp),%ymm13,%ymm13
vpsubq    1152(%rsp),%ymm0,%ymm0
vpaddq    512(%rsp),%ymm0,%ymm0
vpsubq    1184(%rsp),%ymm1,%ymm1
vpaddq    544(%rsp),%ymm1,%ymm1
vpsubq    704(%rsp),%ymm2,%ymm2
vpaddq    576(%rsp),%ymm2,%ymm2
vpsubq    736(%rsp),%ymm3,%ymm3
vpaddq    608(%rsp),%ymm3,%ymm3

vpsrlq    $29,%ymm0,%ymm14
vpaddq    %ymm14,%ymm1,%ymm1
vpand     vecmask29,%ymm0,%ymm0
vpmuludq  vec1216,%ymm0,%ymm0
vpaddq    768(%rsp),%ymm0,%ymm0

vpsrlq    $29,%ymm1,%ymm14
vpaddq    %ymm14,%ymm2,%ymm2
vpand     vecmask29,%ymm1,%ymm1
vpmuludq  vec1216,%ymm1,%ymm1
vpaddq    800(%rsp),%ymm1,%ymm1

vpsrlq    $29,%ymm2,%ymm14
vpaddq    %ymm14,%ymm3,%ymm3
vpand     vecmask29,%ymm2,%ymm2
vpmuludq  vec1216,%ymm2,%ymm2
vpaddq    832(%rsp),%ymm2,%ymm2

vpsrlq    $29,%ymm3,%ymm14
vpaddq    640(%rsp),%ymm14,%ymm14
vpand     vecmask29,%ymm3,%ymm3
vpmuludq  vec1216,%ymm3,%ymm3
vpaddq    864(%rsp),%ymm3,%ymm3

vpsrlq    $29,%ymm14,%ymm15
vpaddq    672(%rsp),%ymm15,%ymm15
vpand     vecmask29,%ymm14,%ymm4
vpmuludq  vec1216,%ymm4,%ymm4
vpaddq    %ymm9,%ymm4,%ymm4

vpsrlq    $29,%ymm15,%ymm14
vpaddq    704(%rsp),%ymm14,%ymm14
vpand     vecmask29,%ymm15,%ymm5
vpmuludq  vec1216,%ymm5,%ymm5
vpaddq    %ymm10,%ymm5,%ymm5

vpsrlq    $29,%ymm14,%ymm15
vpaddq    736(%rsp),%ymm15,%ymm15
vpand     vecmask29,%ymm14,%ymm6
vpmuludq  vec1216,%ymm6,%ymm6
vpaddq    %ymm11,%ymm6,%ymm6

vpsrlq    $29,%ymm15,%ymm8
vpand     vecmask29,%ymm15,%ymm7

vpmuludq  vec1216,%ymm7,%ymm7
vpaddq    %ymm12,%ymm7,%ymm7
vpmuludq  vec1216,%ymm8,%ymm8
vpaddq    %ymm13,%ymm8,%ymm8

vpsrlq    $29,%ymm4,%ymm10
vpaddq    %ymm10,%ymm5,%ymm5
vpand     vecmask29,%ymm4,%ymm4

vpsrlq    $29,%ymm0,%ymm10
vpaddq    %ymm10,%ymm1,%ymm1
vpand     vecmask29,%ymm0,%ymm0

vpsrlq    $29,%ymm5,%ymm10
vpaddq    %ymm10,%ymm6,%ymm6
vpand     vecmask29,%ymm5,%ymm5

vpsrlq    $29,%ymm1,%ymm10
vpaddq    %ymm10,%ymm2,%ymm2
vpand     vecmask29,%ymm1,%ymm1

vpsrlq    $29,%ymm6,%ymm10
vpaddq    %ymm10,%ymm7,%ymm7
vpand     vecmask29,%ymm6,%ymm6

vpsrlq    $29,%ymm2,%ymm10
vpaddq    %ymm10,%ymm3,%ymm3
vpand     vecmask29,%ymm2,%ymm2

vpsrlq    $29,%ymm7,%ymm10
vpaddq    %ymm10,%ymm8,%ymm8
vpand     vecmask29,%ymm7,%ymm7

vpsrlq    $29,%ymm3,%ymm10
vpaddq    %ymm10,%ymm4,%ymm9
vpand     vecmask29,%ymm3,%ymm3

vpsrlq    $23,%ymm8,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpaddq    %ymm10,%ymm10,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpsllq    $3,%ymm10,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpand     vecmask23,%ymm8,%ymm4

vpsrlq    $29,%ymm9,%ymm10
vpaddq    %ymm10,%ymm5,%ymm5
vpand     vecmask29,%ymm9,%ymm9

vpsrlq    $29,%ymm0,%ymm10
vpaddq    %ymm10,%ymm1,%ymm1
vpand     vecmask29,%ymm0,%ymm0

// <X2,Z2,X3,Z3> ← Mulc(<T15,T16,T17,T18>,<1,1,1,X1>)
vpmuludq  0(%rsi),%ymm0,%ymm0
vpmuludq  0(%rsi),%ymm1,%ymm1
vpmuludq  0(%rsi),%ymm2,%ymm2
vpmuludq  0(%rsi),%ymm3,%ymm3
vpmuludq  0(%rsi),%ymm9,%ymm9
vpmuludq  0(%rsi),%ymm5,%ymm5
vpmuludq  0(%rsi),%ymm6,%ymm6
vpmuludq  0(%rsi),%ymm7,%ymm7
vpmuludq  0(%rsi),%ymm4,%ymm4

vpsrlq    $29,%ymm9,%ymm15
vpaddq    %ymm15,%ymm5,%ymm5
vpand     vecmask29,%ymm9,%ymm9

vpsrlq    $29,%ymm0,%ymm15
vpaddq    %ymm15,%ymm1,%ymm1
vpand     vecmask29,%ymm0,%ymm0

vpsrlq    $29,%ymm5,%ymm15
vpaddq    %ymm15,%ymm6,%ymm6
vpand     vecmask29,%ymm5,%ymm5

vpsrlq    $29,%ymm1,%ymm15
vpaddq    %ymm15,%ymm2,%ymm2
vpand     vecmask29,%ymm1,%ymm1

vpsrlq    $29,%ymm6,%ymm15
vpaddq    %ymm15,%ymm7,%ymm7
vpand     vecmask29,%ymm6,%ymm6

vpsrlq    $29,%ymm2,%ymm15
vpaddq    %ymm15,%ymm3,%ymm3
vpand     vecmask29,%ymm2,%ymm2

vpsrlq    $29,%ymm7,%ymm15
vpaddq    %ymm15,%ymm4,%ymm4
vpand     vecmask29,%ymm7,%ymm7

vpsrlq    $29,%ymm3,%ymm15
vpaddq    %ymm15,%ymm9,%ymm9
vpand     vecmask29,%ymm3,%ymm3

vpsrlq    $23,%ymm4,%ymm15
vpmuludq  vec19,%ymm15,%ymm15
vpaddq    %ymm15,%ymm0,%ymm0
vpand     vecmask23,%ymm4,%ymm4

// <X2',Z2',X3',Z3'> ← Pack-N2D(<X2,Z2,X3,Z3>)
vpsllq    $32,%ymm9,%ymm9
vpor      %ymm9,%ymm0,%ymm10
vpsllq    $32,%ymm5,%ymm5
vpor      %ymm5,%ymm1,%ymm11
vpsllq    $32,%ymm6,%ymm6
vpor      %ymm6,%ymm2,%ymm12
vpsllq    $32,%ymm7,%ymm7
vpor      %ymm7,%ymm3,%ymm13

subb      $1,%cl
cmpb	  $0,%cl
jge       .L2

movb	  $7,%cl
subq      $1,%r15
cmpq	  $0,%r15
jge       .L1

// <X2,Z2,X3,Z3> ← Pack-D2N(<X2',Z2',X3',Z3'>)
vpsrlq    $32,%ymm10,%ymm0
vpand     vecmask32,%ymm10,%ymm10
vpsrlq    $32,%ymm11,%ymm1
vpand     vecmask32,%ymm11,%ymm11
vpsrlq    $32,%ymm12,%ymm2
vpand     vecmask32,%ymm12,%ymm12
vpsrlq    $32,%ymm13,%ymm3
vpand     vecmask32,%ymm13,%ymm13

// <X2,Z2,X3,Z3> ← Reduce(<X2,Z2,X3,Z3>)
vpsrlq    $29,%ymm0,%ymm15
vpaddq    %ymm15,%ymm1,%ymm1
vpand     vecmask29,%ymm0,%ymm0

vpsrlq    $29,%ymm10,%ymm15
vpaddq    %ymm15,%ymm11,%ymm11
vpand     vecmask29,%ymm10,%ymm10

vpsrlq    $29,%ymm1,%ymm15
vpaddq    %ymm15,%ymm2,%ymm2
vpand     vecmask29,%ymm1,%ymm1

vpsrlq    $29,%ymm11,%ymm15
vpaddq    %ymm15,%ymm12,%ymm12
vpand     vecmask29,%ymm11,%ymm11

vpsrlq    $29,%ymm2,%ymm15
vpaddq    %ymm15,%ymm3,%ymm3
vpand     vecmask29,%ymm2,%ymm2

vpsrlq    $29,%ymm12,%ymm15
vpaddq    %ymm15,%ymm13,%ymm13
vpand     vecmask29,%ymm12,%ymm12

vpsrlq    $29,%ymm3,%ymm15
vpaddq    %ymm15,%ymm4,%ymm4
vpand     vecmask29,%ymm3,%ymm3

vpsrlq    $29,%ymm13,%ymm15
vpaddq    %ymm15,%ymm0,%ymm0
vpand     vecmask29,%ymm13,%ymm13

vpsrlq    $23,%ymm4,%ymm15
vpaddq    %ymm15,%ymm10,%ymm10
vpaddq    %ymm15,%ymm15,%ymm15
vpaddq    %ymm15,%ymm10,%ymm10
vpsllq    $3,%ymm15,%ymm15
vpaddq    %ymm15,%ymm10,%ymm10
vpand     vecmask23,%ymm4,%ymm4

vpsrlq    $29,%ymm0,%ymm15
vpaddq    %ymm15,%ymm1,%ymm1
vpand     vecmask29,%ymm0,%ymm0

vpsrlq    $29,%ymm10,%ymm15
vpaddq    %ymm15,%ymm11,%ymm11
vpand     vecmask29,%ymm10,%ymm10

// store <X2,Z2,X3,Z3>
vmovdqa   %ymm10,0(%rdi)
vmovdqa   %ymm11,32(%rdi)
vmovdqa   %ymm12,64(%rdi)
vmovdqa   %ymm13,96(%rdi)
vmovdqa   %ymm0,128(%rdi)
vmovdqa   %ymm1,160(%rdi)
vmovdqa   %ymm2,192(%rdi)
vmovdqa   %ymm3,224(%rdi)
vmovdqa   %ymm4,256(%rdi)

movq 	  0(%rsp), %r11
movq 	  8(%rsp), %r12
movq 	  16(%rsp),%r13
movq 	  24(%rsp),%r14
movq 	  32(%rsp),%r15
movq 	  40(%rsp),%rbx
movq 	  48(%rsp),%rbp

movq 	  %r11,%rsp

ret
