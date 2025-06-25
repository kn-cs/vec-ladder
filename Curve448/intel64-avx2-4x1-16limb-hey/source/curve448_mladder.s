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

	.p2align 5
	.globl curve448_mladder
	
curve448_mladder:

	movq 	  %rsp,%r11
	andq 	  $-32,%rsp
	subq 	  $2720,%rsp

	movq 	  %r11,0(%rsp)
	movq 	  %r12,8(%rsp)
	movq 	  %r13,16(%rsp)
	movq 	  %r14,24(%rsp)
	movq 	  %r15,32(%rsp)
	movq 	  %rbx,40(%rsp)
	movq 	  %rbp,48(%rsp) 

	// load <0,A,1,X1>
	vmovdqa   0(%rsi),%ymm8
	vmovdqa   32(%rsi),%ymm9
	vmovdqa   64(%rsi),%ymm10
	vmovdqa   96(%rsi),%ymm11
	vmovdqa   128(%rsi),%ymm12
	vmovdqa   160(%rsi),%ymm13
	vmovdqa   192(%rsi),%ymm14
	vmovdqa   224(%rsi),%ymm15
	vmovdqa   256(%rsi),%ymm0
	vmovdqa   288(%rsi),%ymm1
	vmovdqa   320(%rsi),%ymm2
	vmovdqa   352(%rsi),%ymm3
	vmovdqa   384(%rsi),%ymm4
	vmovdqa   416(%rsi),%ymm5
	vmovdqa   448(%rsi),%ymm6
	vmovdqa   480(%rsi),%ymm7

	// <0',A',1',X1'> ← Pack-N2D(<0,A,1,X1>)
	vpsllq    $32,%ymm0,%ymm0
	vpor      %ymm0,%ymm8,%ymm8
	vpsllq    $32,%ymm1,%ymm1
	vpor      %ymm1,%ymm9,%ymm9
	vpsllq    $32,%ymm2,%ymm2
	vpor      %ymm2,%ymm10,%ymm10
	vpsllq    $32,%ymm3,%ymm3
	vpor      %ymm3,%ymm11,%ymm11
	vpsllq    $32,%ymm4,%ymm4
	vpor      %ymm4,%ymm12,%ymm12
	vpsllq    $32,%ymm5,%ymm5
	vpor      %ymm5,%ymm13,%ymm13
	vpsllq    $32,%ymm6,%ymm6
	vpor      %ymm6,%ymm14,%ymm14
	vpsllq    $32,%ymm7,%ymm7
	vpor      %ymm7,%ymm15,%ymm15

	vmovdqa   %ymm8,0(%rsi)
	vmovdqa   %ymm9,32(%rsi)
	vmovdqa   %ymm10,64(%rsi)
	vmovdqa   %ymm11,96(%rsi)
	vmovdqa   %ymm12,128(%rsi)
	vmovdqa   %ymm13,160(%rsi)
	vmovdqa   %ymm14,192(%rsi)
	vmovdqa   %ymm15,224(%rsi)

	// load <X2,Z2,X3,Z3>
	vmovdqa   0(%rdi),%ymm8
	vmovdqa   32(%rdi),%ymm9
	vmovdqa   64(%rdi),%ymm10
	vmovdqa   96(%rdi),%ymm11
	vmovdqa   128(%rdi),%ymm12
	vmovdqa   160(%rdi),%ymm13
	vmovdqa   192(%rdi),%ymm14
	vmovdqa   224(%rdi),%ymm15
	vmovdqa   256(%rdi),%ymm0
	vmovdqa   288(%rdi),%ymm1
	vmovdqa   320(%rdi),%ymm2
	vmovdqa   352(%rdi),%ymm3
	vmovdqa   384(%rdi),%ymm4
	vmovdqa   416(%rdi),%ymm5
	vmovdqa   448(%rdi),%ymm6
	vmovdqa   480(%rdi),%ymm7

	// <X2',Z2',X3',Z3'> ← Pack-N2D(<X2,Z2,X3,Z3>)
	vpsllq    $32,%ymm0,%ymm0
	vpor      %ymm0,%ymm8,%ymm8
	vpsllq    $32,%ymm1,%ymm1
	vpor      %ymm1,%ymm9,%ymm9
	vpsllq    $32,%ymm2,%ymm2
	vpor      %ymm2,%ymm10,%ymm10
	vpsllq    $32,%ymm3,%ymm3
	vpor      %ymm3,%ymm11,%ymm11
	vpsllq    $32,%ymm4,%ymm4
	vpor      %ymm4,%ymm12,%ymm12
	vpsllq    $32,%ymm5,%ymm5
	vpor      %ymm5,%ymm13,%ymm13
	vpsllq    $32,%ymm6,%ymm6
	vpor      %ymm6,%ymm14,%ymm14
	vpsllq    $32,%ymm7,%ymm7
	vpor      %ymm7,%ymm15,%ymm15

	movq      $55,%r15
	movq	  $7,%rcx

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
	vpbroadcastd 56(%rsp),%ymm1
	vpaddd	  swap_c(%rip),%ymm1,%ymm1
	vpand     swap_mask(%rip),%ymm1,%ymm1

	vpermd	  %ymm8,%ymm1,%ymm8
	vpermd	  %ymm9,%ymm1,%ymm9
	vpermd	  %ymm10,%ymm1,%ymm10
	vpermd	  %ymm11,%ymm1,%ymm11
	vpermd	  %ymm12,%ymm1,%ymm12
	vpermd	  %ymm13,%ymm1,%ymm13
	vpermd	  %ymm14,%ymm1,%ymm14
	vpermd	  %ymm15,%ymm1,%ymm15

	// <T1',T2',T3',T4'> ← Dense-H-H(<X2',Z2',X3',Z3'>)
	vpshufd   $68,%ymm8,%ymm1
	vpshufd   $238,%ymm8,%ymm3
	vpaddd    hh_p1(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm8

	vpshufd   $68,%ymm9,%ymm1
	vpshufd   $238,%ymm9,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm9

	vpshufd   $68,%ymm10,%ymm1
	vpshufd   $238,%ymm10,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm10

	vpshufd   $68,%ymm11,%ymm1
	vpshufd   $238,%ymm11,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm11

	vpshufd   $68,%ymm12,%ymm1
	vpshufd   $238,%ymm12,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm12

	vpshufd   $68,%ymm13,%ymm1
	vpshufd   $238,%ymm13,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm13

	vpshufd   $68,%ymm14,%ymm1
	vpshufd   $238,%ymm14,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm14

	vpshufd   $68,%ymm15,%ymm1
	vpshufd   $238,%ymm15,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm15

	vpsrld    $28,%ymm8,%ymm1
	vpaddd    %ymm1,%ymm9,%ymm9
	vpand     vecmask28d(%rip),%ymm8,%ymm8

	vpsrld    $28,%ymm9,%ymm1
	vpaddd    %ymm1,%ymm10,%ymm10
	vpand     vecmask28d(%rip),%ymm9,%ymm9

	vpsrld    $28,%ymm10,%ymm1
	vpaddd    %ymm1,%ymm11,%ymm11
	vpand     vecmask28d(%rip),%ymm10,%ymm10

	vpsrld    $28,%ymm11,%ymm1
	vpaddd    %ymm1,%ymm12,%ymm12
	vpand     vecmask28d(%rip),%ymm11,%ymm11

	vpsrld    $28,%ymm12,%ymm1
	vpaddd    %ymm1,%ymm13,%ymm13
	vpand     vecmask28d(%rip),%ymm12,%ymm12

	vpsrld    $28,%ymm13,%ymm1
	vpaddd    %ymm1,%ymm14,%ymm14
	vpand     vecmask28d(%rip),%ymm13,%ymm13

	vpsrld    $28,%ymm14,%ymm1
	vpaddd    %ymm1,%ymm15,%ymm15
	vpand     vecmask28d(%rip),%ymm14,%ymm14

	// <T1',T2',T2',T1'> ← Dense-Dup(<T1',T2',T3',T4'>)
	vpermq	  $20,%ymm8,%ymm0
	vpermq	  $20,%ymm9,%ymm1
	vpermq	  $20,%ymm10,%ymm2
	vpermq	  $20,%ymm11,%ymm3
	vpermq	  $20,%ymm12,%ymm4
	vpermq	  $20,%ymm13,%ymm5
	vpermq	  $20,%ymm14,%ymm6
	vpermq	  $20,%ymm15,%ymm7

	// <T1,T2,T2,T1> ← Pack-D2N(<T1',T2',T2',T1'>)
	vmovdqa   %ymm8,64(%rsp)

	vmovdqa   %ymm0,704(%rsp)
	vpsrlq    $32,%ymm0,%ymm8
	vmovdqa   %ymm8,960(%rsp)

	vmovdqa   %ymm1,736(%rsp)
	vpsrlq    $32,%ymm1,%ymm8
	vmovdqa   %ymm8,992(%rsp)

	vmovdqa   %ymm2,768(%rsp)
	vpsrlq    $32,%ymm2,%ymm8
	vmovdqa   %ymm8,1024(%rsp)

	vmovdqa   %ymm3,800(%rsp)
	vpsrlq    $32,%ymm3,%ymm8
	vmovdqa   %ymm8,1056(%rsp)

	vmovdqa   %ymm4,832(%rsp)
	vpsrlq    $32,%ymm4,%ymm8
	vmovdqa   %ymm8,1088(%rsp)

	vmovdqa   %ymm5,864(%rsp)
	vpsrlq    $32,%ymm5,%ymm8
	vmovdqa   %ymm8,1120(%rsp)

	vmovdqa   %ymm6,896(%rsp)
	vpsrlq    $32,%ymm6,%ymm8
	vmovdqa   %ymm8,1152(%rsp)

	vmovdqa   %ymm7,928(%rsp)
	vpsrlq    $32,%ymm7,%ymm8
	vmovdqa   %ymm8,1184(%rsp)

	vmovdqa   64(%rsp),%ymm8

	// <T1,T2,T3,T4> ← Pack-N2D(<T1',T2',T3',T4'>)
	vpsrlq    $32,%ymm8,%ymm0
	vpsrlq    $32,%ymm9,%ymm1
	vpsrlq    $32,%ymm10,%ymm2
	vpsrlq    $32,%ymm11,%ymm3
	vpsrlq    $32,%ymm12,%ymm4
	vpsrlq    $32,%ymm13,%ymm5
	vpsrlq    $32,%ymm14,%ymm6
	vpsrlq    $32,%ymm15,%ymm7

	// <T5,T6,T7,T8> ← Mul(<T1,T2,T3,T4>,<T1,T2,T2,T1>)
	vmovdqa   %ymm14,576(%rsp)
	vmovdqa   %ymm15,608(%rsp)
	vmovdqa   %ymm0,640(%rsp)
	vmovdqa   %ymm1,672(%rsp)

	vpmuludq  960(%rsp),%ymm0,%ymm15
	vmovdqa   %ymm15,1216(%rsp)

	vpmuludq  992(%rsp),%ymm0,%ymm15
	vpmuludq  960(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1248(%rsp)

	vpmuludq  1024(%rsp),%ymm0,%ymm15
	vpmuludq  992(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1280(%rsp)

	vpmuludq  1056(%rsp),%ymm0,%ymm15
	vpmuludq  1024(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1312(%rsp)

	vpmuludq  1088(%rsp),%ymm0,%ymm15
	vpmuludq  1056(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1344(%rsp)

	vpmuludq  1120(%rsp),%ymm0,%ymm15
	vpmuludq  1088(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1376(%rsp)

	vpmuludq  1152(%rsp),%ymm0,%ymm15
	vpmuludq  1120(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1408(%rsp)

	vpmuludq  1184(%rsp),%ymm0,%ymm15
	vpmuludq  1152(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1440(%rsp)

	vpmuludq  1184(%rsp),%ymm1,%ymm15
	vpmuludq  1152(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1472(%rsp)

	vpmuludq  1184(%rsp),%ymm2,%ymm15
	vpmuludq  1152(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1504(%rsp)

	vpmuludq  1184(%rsp),%ymm3,%ymm15
	vpmuludq  1152(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1536(%rsp)

	vpmuludq  1184(%rsp),%ymm4,%ymm15
	vpmuludq  1152(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1568(%rsp)

	vpmuludq  1184(%rsp),%ymm5,%ymm15
	vpmuludq  1152(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1600(%rsp)

	vpmuludq  1184(%rsp),%ymm6,%ymm15
	vpmuludq  1152(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1632(%rsp)

	vpmuludq  1184(%rsp),%ymm7,%ymm15
	vmovdqa   %ymm15,1664(%rsp)

	vmovdqa   576(%rsp),%ymm14
	vmovdqa   608(%rsp),%ymm15

	vpmuludq  704(%rsp),%ymm8,%ymm1
	vmovdqa   %ymm1,1696(%rsp)
	vpaddq    1216(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1216(%rsp)

	vpmuludq  736(%rsp),%ymm8,%ymm1
	vpmuludq  704(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1728(%rsp)
	vpaddq    1248(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1248(%rsp)

	vpmuludq  768(%rsp),%ymm8,%ymm1
	vpmuludq  736(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1760(%rsp)
	vpaddq    1280(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1280(%rsp)

	vpmuludq  800(%rsp),%ymm8,%ymm1
	vpmuludq  768(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1792(%rsp)
	vpaddq    1312(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1312(%rsp)

	vpmuludq  832(%rsp),%ymm8,%ymm1
	vpmuludq  800(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1824(%rsp)
	vpaddq    1344(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1344(%rsp)

	vpmuludq  864(%rsp),%ymm8,%ymm1
	vpmuludq  832(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1856(%rsp)
	vpaddq    1376(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1376(%rsp)

	vpmuludq  896(%rsp),%ymm8,%ymm1
	vpmuludq  864(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1888(%rsp)
	vpaddq    1408(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1408(%rsp)

	vpmuludq  928(%rsp),%ymm8,%ymm1
	vpmuludq  896(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1920(%rsp)
	vpaddq    1440(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1440(%rsp)

	vpmuludq  928(%rsp),%ymm9,%ymm1
	vpmuludq  896(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1952(%rsp)
	vpaddq    1472(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1472(%rsp)

	vpmuludq  928(%rsp),%ymm10,%ymm1
	vpmuludq  896(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1984(%rsp)
	vpaddq    1504(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1504(%rsp)

	vpmuludq  928(%rsp),%ymm11,%ymm1
	vpmuludq  896(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2016(%rsp)
	vpaddq    1536(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1536(%rsp)

	vpmuludq  928(%rsp),%ymm12,%ymm1
	vpmuludq  896(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2048(%rsp)
	vpaddq    1568(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1568(%rsp)

	vpmuludq  928(%rsp),%ymm13,%ymm1
	vpmuludq  896(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2080(%rsp)
	vpaddq    1600(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1600(%rsp)

	vpmuludq  928(%rsp),%ymm14,%ymm1
	vpmuludq  896(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2112(%rsp)
	vpaddq    1632(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1632(%rsp)

	vpmuludq  928(%rsp),%ymm15,%ymm1
	vmovdqa   %ymm1,2144(%rsp)
	vpaddq    1664(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1664(%rsp)

	vpaddq    640(%rsp),%ymm8,%ymm8
	vpaddq    672(%rsp),%ymm9,%ymm9
	vpaddq    %ymm2,%ymm10,%ymm10
	vpaddq    %ymm3,%ymm11,%ymm11
	vpaddq    %ymm4,%ymm12,%ymm12
	vpaddq    %ymm5,%ymm13,%ymm13
	vpaddq    %ymm6,%ymm14,%ymm14
	vpaddq    %ymm7,%ymm15,%ymm15

	vmovdqa   %ymm14,2176(%rsp)
	vmovdqa   %ymm15,2208(%rsp)

	vmovdqa   704(%rsp),%ymm0
	vmovdqa   736(%rsp),%ymm1
	vmovdqa   768(%rsp),%ymm2
	vmovdqa   800(%rsp),%ymm3
	vmovdqa   832(%rsp),%ymm4
	vmovdqa   864(%rsp),%ymm5
	vmovdqa   896(%rsp),%ymm6
	vmovdqa   928(%rsp),%ymm7

	vpaddq    960(%rsp),%ymm0,%ymm0
	vpaddq    992(%rsp),%ymm1,%ymm1
	vpaddq    1024(%rsp),%ymm2,%ymm2
	vpaddq    1056(%rsp),%ymm3,%ymm3
	vpaddq    1088(%rsp),%ymm4,%ymm4
	vpaddq    1120(%rsp),%ymm5,%ymm5
	vpaddq    1152(%rsp),%ymm6,%ymm6
	vpaddq    1184(%rsp),%ymm7,%ymm7

	vpmuludq  %ymm8,%ymm0,%ymm15
	vmovdqa   %ymm15,2240(%rsp)

	vpmuludq  %ymm9,%ymm0,%ymm15
	vpmuludq  %ymm8,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2272(%rsp)

	vpmuludq  %ymm10,%ymm0,%ymm15
	vpmuludq  %ymm9,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2304(%rsp)

	vpmuludq  %ymm11,%ymm0,%ymm15
	vpmuludq  %ymm10,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2336(%rsp)

	vpmuludq  %ymm12,%ymm0,%ymm15
	vpmuludq  %ymm11,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2368(%rsp)

	vpmuludq  %ymm13,%ymm0,%ymm15
	vpmuludq  %ymm12,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2400(%rsp)

	vpmuludq  2176(%rsp),%ymm0,%ymm15
	vpmuludq  %ymm13,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2432(%rsp)

	vpmuludq  2208(%rsp),%ymm0,%ymm15
	vpmuludq  2176(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm8

	vpmuludq  2208(%rsp),%ymm1,%ymm15
	vpmuludq  2176(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm9

	vpmuludq  2208(%rsp),%ymm2,%ymm15
	vpmuludq  2176(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm10

	vpmuludq  2208(%rsp),%ymm3,%ymm15
	vpmuludq  2176(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm11

	vpmuludq  2208(%rsp),%ymm4,%ymm15
	vpmuludq  2176(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm12

	vpmuludq  2208(%rsp),%ymm5,%ymm15
	vpmuludq  2176(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm13

	vpmuludq  2208(%rsp),%ymm6,%ymm15
	vpmuludq  2176(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm14

	vpmuludq  2208(%rsp),%ymm7,%ymm15

	vmovdqa   2240(%rsp),%ymm0
	vmovdqa   2272(%rsp),%ymm1
	vmovdqa   2304(%rsp),%ymm2
	vmovdqa   2336(%rsp),%ymm3
	vmovdqa   2368(%rsp),%ymm4
	vmovdqa   2400(%rsp),%ymm5
	vmovdqa   2432(%rsp),%ymm6

	vpsubq    1696(%rsp),%ymm0,%ymm0
	vpsubq    1728(%rsp),%ymm1,%ymm1
	vpsubq    1760(%rsp),%ymm2,%ymm2
	vpsubq    1792(%rsp),%ymm3,%ymm3
	vpsubq    1824(%rsp),%ymm4,%ymm4
	vpsubq    1856(%rsp),%ymm5,%ymm5
	vpsubq    1888(%rsp),%ymm6,%ymm6
	vpsubq    1920(%rsp),%ymm8,%ymm8
	vpsubq    1952(%rsp),%ymm9,%ymm9
	vpsubq    1984(%rsp),%ymm10,%ymm10
	vpsubq    2016(%rsp),%ymm11,%ymm11
	vpsubq    2048(%rsp),%ymm12,%ymm12
	vpsubq    2080(%rsp),%ymm13,%ymm13
	vpsubq    2112(%rsp),%ymm14,%ymm14
	vpsubq    2144(%rsp),%ymm15,%ymm15

	vpaddq    1472(%rsp),%ymm0,%ymm0
	vpaddq    1504(%rsp),%ymm1,%ymm1
	vpaddq    1536(%rsp),%ymm2,%ymm2
	vpaddq    1568(%rsp),%ymm3,%ymm3
	vpaddq    1600(%rsp),%ymm4,%ymm4
	vpaddq    1632(%rsp),%ymm5,%ymm5
	vpaddq    1664(%rsp),%ymm6,%ymm6

	vpaddq    %ymm9,%ymm0,%ymm0
	vpaddq    %ymm10,%ymm1,%ymm1
	vpaddq    %ymm11,%ymm2,%ymm2
	vpaddq    %ymm12,%ymm3,%ymm3
	vpaddq    %ymm13,%ymm4,%ymm4
	vpaddq    %ymm14,%ymm5,%ymm5
	vpaddq    %ymm15,%ymm6,%ymm6

	vpaddq    1216(%rsp),%ymm9,%ymm9
	vpaddq    1248(%rsp),%ymm10,%ymm10
	vpaddq    1280(%rsp),%ymm11,%ymm11
	vpaddq    1312(%rsp),%ymm12,%ymm12
	vpaddq    1344(%rsp),%ymm13,%ymm13
	vpaddq    1376(%rsp),%ymm14,%ymm14
	vpaddq    1408(%rsp),%ymm15,%ymm15

	vmovdqa   %ymm8,64(%rsp)

	vpsrlq    $28,%ymm9,%ymm7
	vpaddq    %ymm7,%ymm10,%ymm10
	vpand     vecmask28(%rip),%ymm9,%ymm8

	vpsrlq    $28,%ymm0,%ymm7
	vpaddq    %ymm7,%ymm1,%ymm1
	vpand     vecmask28(%rip),%ymm0,%ymm0

	vpsrlq    $28,%ymm10,%ymm7
	vpaddq    %ymm7,%ymm11,%ymm11
	vpand     vecmask28(%rip),%ymm10,%ymm9

	vpsrlq    $28,%ymm1,%ymm7
	vpaddq    %ymm7,%ymm2,%ymm2
	vpand     vecmask28(%rip),%ymm1,%ymm1

	vpsrlq    $28,%ymm11,%ymm7
	vpaddq    %ymm7,%ymm12,%ymm12
	vpand     vecmask28(%rip),%ymm11,%ymm10

	vpsrlq    $28,%ymm2,%ymm7
	vpaddq    %ymm7,%ymm3,%ymm3
	vpand     vecmask28(%rip),%ymm2,%ymm2

	vpsrlq    $28,%ymm12,%ymm7
	vpaddq    %ymm7,%ymm13,%ymm13
	vpand     vecmask28(%rip),%ymm12,%ymm11

	vpsrlq    $28,%ymm3,%ymm7
	vpaddq    %ymm7,%ymm4,%ymm4
	vpand     vecmask28(%rip),%ymm3,%ymm3

	vpsrlq    $28,%ymm13,%ymm7
	vpaddq    %ymm7,%ymm14,%ymm14
	vpand     vecmask28(%rip),%ymm13,%ymm12

	vpsrlq    $28,%ymm4,%ymm7
	vpaddq    %ymm7,%ymm5,%ymm5
	vpand     vecmask28(%rip),%ymm4,%ymm4

	vpsrlq    $28,%ymm14,%ymm7
	vpaddq    %ymm7,%ymm15,%ymm15
	vpand     vecmask28(%rip),%ymm14,%ymm13

	vpsrlq    $28,%ymm5,%ymm7
	vpaddq    %ymm7,%ymm6,%ymm6
	vpand     vecmask28(%rip),%ymm5,%ymm5

	vmovdqa   %ymm10,128(%rsp)
	vpsrlq    $28,%ymm15,%ymm10
	vpaddq    1440(%rsp),%ymm10,%ymm10
	vpand     vecmask28(%rip),%ymm15,%ymm14

	vpsrlq    $28,%ymm6,%ymm7
	vpaddq    64(%rsp),%ymm7,%ymm7
	vpand     vecmask28(%rip),%ymm6,%ymm6

	vmovdqa   %ymm11,160(%rsp)
	vpsrlq    $28,%ymm10,%ymm11
	vpaddq    %ymm11,%ymm0,%ymm0
	vpand     vecmask28(%rip),%ymm10,%ymm15

	vpsrlq    $28,%ymm7,%ymm11
	vpaddq    %ymm11,%ymm8,%ymm8
	vpaddq    %ymm11,%ymm0,%ymm0
	vpand     vecmask28(%rip),%ymm7,%ymm7

	vpsrlq    $28,%ymm8,%ymm11
	vpaddq    %ymm11,%ymm9,%ymm9
	vpand     vecmask28(%rip),%ymm8,%ymm8

	vpsrlq    $28,%ymm0,%ymm11
	vpaddq    %ymm11,%ymm1,%ymm1
	vpand     vecmask28(%rip),%ymm0,%ymm0

	vmovdqa   128(%rsp),%ymm10
	vmovdqa   160(%rsp),%ymm11

	// <T5',T6',T7',T8'> ← Pack-N2D(<T5,T6,T7,T8>)
	vpsllq    $32,%ymm0,%ymm0
	vpor      %ymm0,%ymm8,%ymm8
	vpsllq    $32,%ymm1,%ymm1
	vpor      %ymm1,%ymm9,%ymm9
	vpsllq    $32,%ymm2,%ymm2
	vpor      %ymm2,%ymm10,%ymm10
	vpsllq    $32,%ymm3,%ymm3
	vpor      %ymm3,%ymm11,%ymm11
	vpsllq    $32,%ymm4,%ymm4
	vpor      %ymm4,%ymm12,%ymm12
	vpsllq    $32,%ymm5,%ymm5
	vpor      %ymm5,%ymm13,%ymm13
	vpsllq    $32,%ymm6,%ymm6
	vpor      %ymm6,%ymm14,%ymm14
	vpsllq    $32,%ymm7,%ymm7
	vpor      %ymm7,%ymm15,%ymm15

	// <T9',T10',T11',T12'> ← Dense-H-H(<T5',T6',T7',T8'>)
	vpshufd   $68,%ymm8,%ymm1
	vpshufd   $238,%ymm8,%ymm3
	vpaddd    hh_p1(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm8

	vpshufd   $68,%ymm9,%ymm1
	vpshufd   $238,%ymm9,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm9

	vpshufd   $68,%ymm10,%ymm1
	vpshufd   $238,%ymm10,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm10

	vpshufd   $68,%ymm11,%ymm1
	vpshufd   $238,%ymm11,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm11

	vpshufd   $68,%ymm12,%ymm1
	vpshufd   $238,%ymm12,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm12

	vpshufd   $68,%ymm13,%ymm1
	vpshufd   $238,%ymm13,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm13

	vpshufd   $68,%ymm14,%ymm1
	vpshufd   $238,%ymm14,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm14

	vpshufd   $68,%ymm15,%ymm1
	vpshufd   $238,%ymm15,%ymm3
	vpaddd    hh_p2(%rip),%ymm1,%ymm1
	vpxor     hh_xor(%rip),%ymm3,%ymm3
	vpaddd    %ymm1,%ymm3,%ymm15

	vpsrld    $28,%ymm8,%ymm1
	vpaddd    %ymm1,%ymm9,%ymm9
	vpand     vecmask28d(%rip),%ymm8,%ymm8

	vpsrld    $28,%ymm9,%ymm1
	vpaddd    %ymm1,%ymm10,%ymm10
	vpand     vecmask28d(%rip),%ymm9,%ymm9

	vpsrld    $28,%ymm10,%ymm1
	vpaddd    %ymm1,%ymm11,%ymm11
	vpand     vecmask28d(%rip),%ymm10,%ymm10

	vpsrld    $28,%ymm11,%ymm1
	vpaddd    %ymm1,%ymm12,%ymm12
	vpand     vecmask28d(%rip),%ymm11,%ymm11

	vpsrld    $28,%ymm12,%ymm1
	vpaddd    %ymm1,%ymm13,%ymm13
	vpand     vecmask28d(%rip),%ymm12,%ymm12

	vpsrld    $28,%ymm13,%ymm1
	vpaddd    %ymm1,%ymm14,%ymm14
	vpand     vecmask28d(%rip),%ymm13,%ymm13

	vpsrld    $28,%ymm14,%ymm1
	vpaddd    %ymm1,%ymm15,%ymm15
	vpand     vecmask28d(%rip),%ymm14,%ymm14

	vmovdqa   %ymm8,64(%rsp)
	vmovdqa   %ymm9,96(%rsp)
	vmovdqa   %ymm10,128(%rsp)
	vmovdqa   %ymm11,160(%rsp)
	vmovdqa   %ymm12,192(%rsp)
	vmovdqa   %ymm13,224(%rsp)
	vmovdqa   %ymm14,256(%rsp)
	vmovdqa   %ymm15,288(%rsp)

	// <T10',T9',T12',T11'> ← Dense-Shuffle(<T9',T10',T11',T12'>)
	vpshufd   $78,%ymm8,%ymm0
	vpshufd   $78,%ymm9,%ymm1
	vpshufd   $78,%ymm10,%ymm2
	vpshufd   $78,%ymm11,%ymm3
	vpshufd   $78,%ymm12,%ymm4
	vpshufd   $78,%ymm13,%ymm5
	vpshufd   $78,%ymm14,%ymm6
	vpshufd   $78,%ymm15,%ymm7

	// <T10',A',1',X1'> ← Dense-Blend(<0',A',1',X1'>,<T10',T9',T12',T11'>,1000)
	vpblendd  $252,0(%rsi),%ymm0,%ymm0
	vpblendd  $252,32(%rsi),%ymm1,%ymm1
	vpblendd  $252,64(%rsi),%ymm2,%ymm2
	vpblendd  $252,96(%rsi),%ymm3,%ymm3
	vpblendd  $252,128(%rsi),%ymm4,%ymm4
	vpblendd  $252,160(%rsi),%ymm5,%ymm5
	vpblendd  $252,192(%rsi),%ymm6,%ymm6
	vpblendd  $252,224(%rsi),%ymm7,%ymm7

	// <T10,A,1,X1> ← Pack-D2N(<T10',A',1',X1'>)
	vmovdqa   %ymm0,704(%rsp)
	vpsrlq    $32,%ymm0,%ymm0
	vmovdqa   %ymm0,960(%rsp)
	vmovdqa   %ymm1,736(%rsp)
	vpsrlq    $32,%ymm1,%ymm1
	vmovdqa   %ymm1,992(%rsp)
	vmovdqa   %ymm2,768(%rsp)
	vpsrlq    $32,%ymm2,%ymm2
	vmovdqa   %ymm2,1024(%rsp)
	vmovdqa   %ymm3,800(%rsp)
	vpsrlq    $32,%ymm3,%ymm3
	vmovdqa   %ymm3,1056(%rsp)
	vmovdqa   %ymm4,832(%rsp)
	vpsrlq    $32,%ymm4,%ymm4
	vmovdqa   %ymm4,1088(%rsp)
	vmovdqa   %ymm5,864(%rsp)
	vpsrlq    $32,%ymm5,%ymm5
	vmovdqa   %ymm5,1120(%rsp)
	vmovdqa   %ymm6,896(%rsp)
	vpsrlq    $32,%ymm6,%ymm6
	vmovdqa   %ymm6,1152(%rsp)
	vmovdqa   %ymm7,928(%rsp)
	vpsrlq    $32,%ymm7,%ymm7
	vmovdqa   %ymm7,1184(%rsp)

	// <T9,T10,T11,T12> ← Pack-D2N(<T9',T10',T11',T12'>)
	vpsrlq    $32,%ymm8,%ymm0
	vpsrlq    $32,%ymm9,%ymm1
	vpsrlq    $32,%ymm10,%ymm2
	vpsrlq    $32,%ymm11,%ymm3
	vpsrlq    $32,%ymm12,%ymm4
	vpsrlq    $32,%ymm13,%ymm5
	vpsrlq    $32,%ymm14,%ymm6
	vpsrlq    $32,%ymm15,%ymm7

	// <T13,T14,T15,T16> ← Sqr(<T9,T10,T11,T12>)
	vmovdqa    %ymm0,576(%rsp)
	vmovdqa    %ymm1,608(%rsp)

	vpmuludq  %ymm0,%ymm0,%ymm15
	vmovdqa   %ymm15,1216(%rsp)

	vpmuludq  %ymm1,%ymm0,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vmovdqa   %ymm15,1248(%rsp)

	vpmuludq  %ymm2,%ymm0,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vpmuludq  %ymm1,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1280(%rsp)

	vpmuludq  %ymm3,%ymm0,%ymm15
	vpmuludq  %ymm2,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vmovdqa   %ymm15,1312(%rsp)

	vpmuludq  %ymm4,%ymm0,%ymm15
	vpmuludq  %ymm3,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vpmuludq  %ymm2,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1344(%rsp)

	vpmuludq  %ymm5,%ymm0,%ymm15
	vpmuludq  %ymm4,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm3,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vmovdqa   %ymm15,1376(%rsp)

	vpmuludq  %ymm6,%ymm0,%ymm15
	vpmuludq  %ymm5,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm4,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vpmuludq  %ymm3,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1408(%rsp)

	vpmuludq  %ymm7,%ymm0,%ymm15
	vpmuludq  %ymm6,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm5,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm4,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vmovdqa   %ymm15,1440(%rsp)

	vpmuludq  %ymm7,%ymm1,%ymm15
	vpmuludq  %ymm6,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm5,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vpmuludq  %ymm4,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1472(%rsp)

	vpmuludq  %ymm7,%ymm2,%ymm15
	vpmuludq  %ymm6,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm5,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vmovdqa   %ymm15,1504(%rsp)

	vpmuludq  %ymm7,%ymm3,%ymm15
	vpmuludq  %ymm6,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vpmuludq  %ymm5,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1536(%rsp)

	vpmuludq  %ymm7,%ymm4,%ymm15
	vpmuludq  %ymm6,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vmovdqa   %ymm15,1568(%rsp)

	vpmuludq  %ymm7,%ymm5,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vpmuludq  %ymm6,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1600(%rsp)

	vpmuludq  %ymm7,%ymm6,%ymm15
	vpaddq    %ymm15,%ymm15,%ymm15
	vmovdqa   %ymm15,1632(%rsp)

	vpmuludq  %ymm7,%ymm7,%ymm15
	vmovdqa   %ymm15,1664(%rsp)

	vmovdqa   256(%rsp),%ymm14
	vmovdqa   288(%rsp),%ymm15

	vpmuludq  %ymm8,%ymm8,%ymm1
	vmovdqa   %ymm1,1696(%rsp)
	vpaddq    1216(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1216(%rsp)

	vpmuludq  %ymm9,%ymm8,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vmovdqa   %ymm1,1728(%rsp)
	vpaddq    1248(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1248(%rsp)

	vpmuludq  %ymm10,%ymm8,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm9,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1760(%rsp)
	vpaddq    1280(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1280(%rsp)

	vpmuludq  %ymm11,%ymm8,%ymm1
	vpmuludq  %ymm10,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vmovdqa   %ymm1,1792(%rsp)
	vpaddq    1312(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1312(%rsp)

	vpmuludq  %ymm12,%ymm8,%ymm1
	vpmuludq  %ymm11,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm10,%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1824(%rsp)
	vpaddq    1344(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1344(%rsp)

	vpmuludq  %ymm13,%ymm8,%ymm1
	vpmuludq  %ymm12,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm11,%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vmovdqa   %ymm1,1856(%rsp)
	vpaddq    1376(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1376(%rsp)

	vpmuludq  %ymm14,%ymm8,%ymm1
	vpmuludq  %ymm13,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm12,%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm11,%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1888(%rsp)
	vpaddq    1408(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1408(%rsp)

	vpmuludq  %ymm15,%ymm8,%ymm1
	vpmuludq  %ymm14,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm13,%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm12,%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vmovdqa   %ymm1,1920(%rsp)
	vpaddq    1440(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1440(%rsp)

	vpmuludq  %ymm15,%ymm9,%ymm1
	vpmuludq  %ymm14,%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm13,%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm12,%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1952(%rsp)
	vpaddq    1472(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1472(%rsp)

	vpmuludq  %ymm15,%ymm10,%ymm1
	vpmuludq  %ymm14,%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm13,%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vmovdqa   %ymm1,1984(%rsp)
	vpaddq    1504(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1504(%rsp)

	vpmuludq  %ymm15,%ymm11,%ymm1
	vpmuludq  %ymm14,%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm13,%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2016(%rsp)
	vpaddq    1536(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1536(%rsp)

	vpmuludq  %ymm15,%ymm12,%ymm1
	vpmuludq  %ymm14,%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vmovdqa   %ymm1,2048(%rsp)
	vpaddq    1568(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1568(%rsp)

	vpmuludq  %ymm15,%ymm13,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm14,%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2080(%rsp)
	vpaddq    1600(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1600(%rsp)

	vpmuludq  %ymm15,%ymm14,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vmovdqa   %ymm1,2112(%rsp)
	vpaddq    1632(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1632(%rsp)

	vpmuludq  %ymm15,%ymm15,%ymm1
	vmovdqa   %ymm1,2144(%rsp)
	vpaddq    1664(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1664(%rsp)

	vpaddq    576(%rsp),%ymm8,%ymm8
	vpaddq    608(%rsp),%ymm9,%ymm9
	vpaddq    %ymm2,%ymm10,%ymm10
	vpaddq    %ymm3,%ymm11,%ymm11
	vpaddq    %ymm4,%ymm12,%ymm12
	vpaddq    %ymm5,%ymm13,%ymm13
	vpaddq    %ymm6,%ymm14,%ymm14
	vpaddq    %ymm7,%ymm15,%ymm15

	vpmuludq  %ymm8,%ymm8,%ymm1
	vmovdqa   %ymm1,2176(%rsp)

	vpmuludq  %ymm9,%ymm8,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vmovdqa   %ymm1,2208(%rsp)

	vpmuludq  %ymm10,%ymm8,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm9,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2240(%rsp)

	vpmuludq  %ymm11,%ymm8,%ymm1
	vpmuludq  %ymm10,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vmovdqa   %ymm1,2272(%rsp)

	vpmuludq  %ymm12,%ymm8,%ymm1
	vpmuludq  %ymm11,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm10,%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2304(%rsp)

	vpmuludq  %ymm13,%ymm8,%ymm1
	vpmuludq  %ymm12,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm11,%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vmovdqa   %ymm1,2336(%rsp)

	vpmuludq  %ymm14,%ymm8,%ymm1
	vpmuludq  %ymm13,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm12,%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm11,%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2368(%rsp)

	vpmuludq  %ymm15,%ymm8,%ymm1
	vpmuludq  %ymm14,%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm13,%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm12,%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm8

	vpmuludq  %ymm15,%ymm9,%ymm1
	vpmuludq  %ymm14,%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm13,%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm12,%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm9

	vpmuludq  %ymm15,%ymm10,%ymm1
	vpmuludq  %ymm14,%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  %ymm13,%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm10

	vpmuludq  %ymm15,%ymm11,%ymm1
	vpmuludq  %ymm14,%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm13,%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm11

	vpmuludq  %ymm15,%ymm12,%ymm1
	vpmuludq  %ymm14,%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm12

	vpmuludq  %ymm15,%ymm13,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm1
	vpmuludq  %ymm14,%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm13

	vpmuludq  %ymm15,%ymm14,%ymm1
	vpaddq    %ymm1,%ymm1,%ymm14

	vpmuludq  %ymm15,%ymm15,%ymm15

	vmovdqa   2176(%rsp),%ymm0
	vmovdqa   2208(%rsp),%ymm1
	vmovdqa   2240(%rsp),%ymm2
	vmovdqa   2272(%rsp),%ymm3
	vmovdqa   2304(%rsp),%ymm4
	vmovdqa   2336(%rsp),%ymm5
	vmovdqa   2368(%rsp),%ymm6

	vpsubq    1696(%rsp),%ymm0,%ymm0
	vpsubq    1728(%rsp),%ymm1,%ymm1
	vpsubq    1760(%rsp),%ymm2,%ymm2
	vpsubq    1792(%rsp),%ymm3,%ymm3
	vpsubq    1824(%rsp),%ymm4,%ymm4
	vpsubq    1856(%rsp),%ymm5,%ymm5
	vpsubq    1888(%rsp),%ymm6,%ymm6
	vpsubq    1920(%rsp),%ymm8,%ymm8
	vpsubq    1952(%rsp),%ymm9,%ymm9
	vpsubq    1984(%rsp),%ymm10,%ymm10
	vpsubq    2016(%rsp),%ymm11,%ymm11
	vpsubq    2048(%rsp),%ymm12,%ymm12
	vpsubq    2080(%rsp),%ymm13,%ymm13
	vpsubq    2112(%rsp),%ymm14,%ymm14
	vpsubq    2144(%rsp),%ymm15,%ymm15

	vpaddq    1472(%rsp),%ymm0,%ymm0
	vpaddq    1504(%rsp),%ymm1,%ymm1
	vpaddq    1536(%rsp),%ymm2,%ymm2
	vpaddq    1568(%rsp),%ymm3,%ymm3
	vpaddq    1600(%rsp),%ymm4,%ymm4
	vpaddq    1632(%rsp),%ymm5,%ymm5
	vpaddq    1664(%rsp),%ymm6,%ymm6

	vpaddq    %ymm9,%ymm0,%ymm0
	vpaddq    %ymm10,%ymm1,%ymm1
	vpaddq    %ymm11,%ymm2,%ymm2
	vpaddq    %ymm12,%ymm3,%ymm3
	vpaddq    %ymm13,%ymm4,%ymm4
	vpaddq    %ymm14,%ymm5,%ymm5
	vpaddq    %ymm15,%ymm6,%ymm6

	vpaddq    1216(%rsp),%ymm9,%ymm9
	vpaddq    1248(%rsp),%ymm10,%ymm10
	vpaddq    1280(%rsp),%ymm11,%ymm11
	vpaddq    1312(%rsp),%ymm12,%ymm12
	vpaddq    1344(%rsp),%ymm13,%ymm13
	vpaddq    1376(%rsp),%ymm14,%ymm14
	vpaddq    1408(%rsp),%ymm15,%ymm15

	vmovdqa   %ymm8,576(%rsp)

	vpsrlq    $28,%ymm9,%ymm7
	vpaddq    %ymm7,%ymm10,%ymm10
	vpand     vecmask28(%rip),%ymm9,%ymm8

	vpsrlq    $28,%ymm0,%ymm7
	vpaddq    %ymm7,%ymm1,%ymm1
	vpand     vecmask28(%rip),%ymm0,%ymm0

	vpsrlq    $28,%ymm10,%ymm7
	vpaddq    %ymm7,%ymm11,%ymm11
	vpand     vecmask28(%rip),%ymm10,%ymm9

	vpsrlq    $28,%ymm1,%ymm7
	vpaddq    %ymm7,%ymm2,%ymm2
	vpand     vecmask28(%rip),%ymm1,%ymm1

	vpsrlq    $28,%ymm11,%ymm7
	vpaddq    %ymm7,%ymm12,%ymm12
	vpand     vecmask28(%rip),%ymm11,%ymm10

	vpsrlq    $28,%ymm2,%ymm7
	vpaddq    %ymm7,%ymm3,%ymm3
	vpand     vecmask28(%rip),%ymm2,%ymm2

	vpsrlq    $28,%ymm12,%ymm7
	vpaddq    %ymm7,%ymm13,%ymm13
	vpand     vecmask28(%rip),%ymm12,%ymm11

	vpsrlq    $28,%ymm3,%ymm7
	vpaddq    %ymm7,%ymm4,%ymm4
	vpand     vecmask28(%rip),%ymm3,%ymm3

	vpsrlq    $28,%ymm13,%ymm7
	vpaddq    %ymm7,%ymm14,%ymm14
	vpand     vecmask28(%rip),%ymm13,%ymm12

	vpsrlq    $28,%ymm4,%ymm7
	vpaddq    %ymm7,%ymm5,%ymm5
	vpand     vecmask28(%rip),%ymm4,%ymm4

	vpsrlq    $28,%ymm14,%ymm7
	vpaddq    %ymm7,%ymm15,%ymm15
	vpand     vecmask28(%rip),%ymm14,%ymm13

	vpsrlq    $28,%ymm5,%ymm7
	vpaddq    %ymm7,%ymm6,%ymm6
	vpand     vecmask28(%rip),%ymm5,%ymm5

	vmovdqa   %ymm10,608(%rsp)
	vpsrlq    $28,%ymm15,%ymm10
	vpaddq    1440(%rsp),%ymm10,%ymm10
	vpand     vecmask28(%rip),%ymm15,%ymm14

	vpsrlq    $28,%ymm6,%ymm7
	vpaddq    576(%rsp),%ymm7,%ymm7
	vpand     vecmask28(%rip),%ymm6,%ymm6

	vmovdqa   %ymm11,640(%rsp)
	vpsrlq    $28,%ymm10,%ymm11
	vpaddq    %ymm11,%ymm0,%ymm0
	vpand     vecmask28(%rip),%ymm10,%ymm15

	vpsrlq    $28,%ymm7,%ymm11
	vpaddq    %ymm11,%ymm8,%ymm8
	vpaddq    %ymm11,%ymm0,%ymm0
	vpand     vecmask28(%rip),%ymm7,%ymm7

	vpsrlq    $28,%ymm8,%ymm11
	vpaddq    %ymm11,%ymm9,%ymm9
	vpand     vecmask28(%rip),%ymm8,%ymm8

	vpsrlq    $28,%ymm0,%ymm11
	vpaddq    %ymm11,%ymm1,%ymm1
	vpand     vecmask28(%rip),%ymm0,%ymm0

	vmovdqa   608(%rsp),%ymm10
	vmovdqa   640(%rsp),%ymm11

	// <T13',T14',T15',T16'> ← Pack-N2D(<T13,T14,T15,T16>)
	vpsllq    $32,%ymm0,%ymm0
	vpor      %ymm0,%ymm8,%ymm8
	vpsllq    $32,%ymm1,%ymm1
	vpor      %ymm1,%ymm9,%ymm9
	vpsllq    $32,%ymm2,%ymm2
	vpor      %ymm2,%ymm10,%ymm10
	vpsllq    $32,%ymm3,%ymm3
	vpor      %ymm3,%ymm11,%ymm11
	vpsllq    $32,%ymm4,%ymm4
	vpor      %ymm4,%ymm12,%ymm12
	vpsllq    $32,%ymm5,%ymm5
	vpor      %ymm5,%ymm13,%ymm13
	vpsllq    $32,%ymm6,%ymm6
	vpor      %ymm6,%ymm14,%ymm14
	vpsllq    $32,%ymm7,%ymm7
	vpor      %ymm7,%ymm15,%ymm15

	vmovdqa   %ymm8,320(%rsp)
	vmovdqa   %ymm9,352(%rsp)
	vmovdqa   %ymm10,384(%rsp)
	vmovdqa   %ymm11,416(%rsp)
	vmovdqa   %ymm12,448(%rsp)
	vmovdqa   %ymm13,480(%rsp)
	vmovdqa   %ymm14,512(%rsp)
	vmovdqa   %ymm15,544(%rsp)

	// <T14',T13',T16',T15'> ← Dense-Shuffle(<T13',T14',T15',T16'>)
	vpshufd   $78,%ymm8,%ymm0
	vpshufd   $78,%ymm9,%ymm1
	vpshufd   $78,%ymm10,%ymm2
	vpshufd   $78,%ymm11,%ymm3
	vpshufd   $78,%ymm12,%ymm4
	vpshufd   $78,%ymm13,%ymm5
	vpshufd   $78,%ymm14,%ymm6
	vpshufd   $78,%ymm15,%ymm7

	// <X2',*,*,*> ← Dense-Sub(<T13',T14',T15',T16'>,<T14',T13',T16',T15'>)
	vpaddd	  sub_p1(%rip),%ymm8,%ymm8
	vpaddd	  sub_p2(%rip),%ymm9,%ymm9
	vpaddd	  sub_p2(%rip),%ymm10,%ymm10
	vpaddd	  sub_p2(%rip),%ymm11,%ymm11
	vpaddd	  sub_p2(%rip),%ymm12,%ymm12
	vpaddd	  sub_p2(%rip),%ymm13,%ymm13
	vpaddd	  sub_p2(%rip),%ymm14,%ymm14
	vpaddd	  sub_p2(%rip),%ymm15,%ymm15
	vpsubd	  %ymm0,%ymm8,%ymm8
	vpsubd	  %ymm1,%ymm9,%ymm9
	vpsubd	  %ymm2,%ymm10,%ymm10
	vpsubd	  %ymm3,%ymm11,%ymm11
	vpsubd	  %ymm4,%ymm12,%ymm12
	vpsubd	  %ymm5,%ymm13,%ymm13
	vpsubd	  %ymm6,%ymm14,%ymm14
	vpsubd	  %ymm7,%ymm15,%ymm15

	vmovdqa   %ymm8,2464(%rsp)
	vmovdqa   %ymm9,2496(%rsp)
	vmovdqa   %ymm10,2528(%rsp)
	vmovdqa   %ymm11,2560(%rsp)
	vmovdqa   %ymm12,2592(%rsp)
	vmovdqa   %ymm13,2624(%rsp)
	vmovdqa   %ymm14,2656(%rsp)
	vmovdqa   %ymm15,2688(%rsp)

	// <T9',T14',T15',T16'> ← Dense-Blend(<T9',T10',T11',T12'>,<T13',T14',T15',T16'>,0111)
	vmovdqa   320(%rsp),%ymm8
	vmovdqa   352(%rsp),%ymm9
	vmovdqa   384(%rsp),%ymm10
	vmovdqa   416(%rsp),%ymm11
	vmovdqa   448(%rsp),%ymm12
	vmovdqa   480(%rsp),%ymm13
	vmovdqa   512(%rsp),%ymm14
	vmovdqa   544(%rsp),%ymm15
	vpblendd  $3,64(%rsp),%ymm8,%ymm8
	vpblendd  $3,96(%rsp),%ymm9,%ymm9
	vpblendd  $3,128(%rsp),%ymm10,%ymm10
	vpblendd  $3,160(%rsp),%ymm11,%ymm11
	vpblendd  $3,192(%rsp),%ymm12,%ymm12
	vpblendd  $3,224(%rsp),%ymm13,%ymm13
	vpblendd  $3,256(%rsp),%ymm14,%ymm14
	vpblendd  $3,288(%rsp),%ymm15,%ymm15

	// <T9,T14,T15,T16> ← Pack-D2N(<T9',T14',T15',T16'>)
	vpsrlq    $32,%ymm8,%ymm0
	vpsrlq    $32,%ymm9,%ymm1
	vpsrlq    $32,%ymm10,%ymm2
	vpsrlq    $32,%ymm11,%ymm3
	vpsrlq    $32,%ymm12,%ymm4
	vpsrlq    $32,%ymm13,%ymm5
	vpsrlq    $32,%ymm14,%ymm6
	vpsrlq    $32,%ymm15,%ymm7

	// <T17,T18,X3,Z3> ← Mul(<T10,A,1,X1>,<T9,T14,T15,T16>)
	vmovdqa   %ymm14,576(%rsp)
	vmovdqa   %ymm15,608(%rsp)
	vmovdqa   %ymm0,640(%rsp)
	vmovdqa   %ymm1,672(%rsp)

	vpmuludq  960(%rsp),%ymm0,%ymm15
	vmovdqa   %ymm15,1216(%rsp)

	vpmuludq  992(%rsp),%ymm0,%ymm15
	vpmuludq  960(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1248(%rsp)

	vpmuludq  1024(%rsp),%ymm0,%ymm15
	vpmuludq  992(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1280(%rsp)

	vpmuludq  1056(%rsp),%ymm0,%ymm15
	vpmuludq  1024(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1312(%rsp)

	vpmuludq  1088(%rsp),%ymm0,%ymm15
	vpmuludq  1056(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1344(%rsp)

	vpmuludq  1120(%rsp),%ymm0,%ymm15
	vpmuludq  1088(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1376(%rsp)

	vpmuludq  1152(%rsp),%ymm0,%ymm15
	vpmuludq  1120(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1408(%rsp)

	vpmuludq  1184(%rsp),%ymm0,%ymm15
	vpmuludq  1152(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  960(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1440(%rsp)

	vpmuludq  1184(%rsp),%ymm1,%ymm15
	vpmuludq  1152(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  992(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1472(%rsp)

	vpmuludq  1184(%rsp),%ymm2,%ymm15
	vpmuludq  1152(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1024(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1504(%rsp)

	vpmuludq  1184(%rsp),%ymm3,%ymm15
	vpmuludq  1152(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1056(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1536(%rsp)

	vpmuludq  1184(%rsp),%ymm4,%ymm15
	vpmuludq  1152(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1088(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1568(%rsp)

	vpmuludq  1184(%rsp),%ymm5,%ymm15
	vpmuludq  1152(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  1120(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1600(%rsp)

	vpmuludq  1184(%rsp),%ymm6,%ymm15
	vpmuludq  1152(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,1632(%rsp)

	vpmuludq  1184(%rsp),%ymm7,%ymm15
	vmovdqa   %ymm15,1664(%rsp)

	vmovdqa   576(%rsp),%ymm14
	vmovdqa   608(%rsp),%ymm15

	vpmuludq  704(%rsp),%ymm8,%ymm1
	vmovdqa   %ymm1,1696(%rsp)
	vpaddq    1216(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1216(%rsp)

	vpmuludq  736(%rsp),%ymm8,%ymm1
	vpmuludq  704(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1728(%rsp)
	vpaddq    1248(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1248(%rsp)

	vpmuludq  768(%rsp),%ymm8,%ymm1
	vpmuludq  736(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1760(%rsp)
	vpaddq    1280(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1280(%rsp)

	vpmuludq  800(%rsp),%ymm8,%ymm1
	vpmuludq  768(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1792(%rsp)
	vpaddq    1312(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1312(%rsp)

	vpmuludq  832(%rsp),%ymm8,%ymm1
	vpmuludq  800(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1824(%rsp)
	vpaddq    1344(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1344(%rsp)

	vpmuludq  864(%rsp),%ymm8,%ymm1
	vpmuludq  832(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1856(%rsp)
	vpaddq    1376(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1376(%rsp)

	vpmuludq  896(%rsp),%ymm8,%ymm1
	vpmuludq  864(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1888(%rsp)
	vpaddq    1408(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1408(%rsp)

	vpmuludq  928(%rsp),%ymm8,%ymm1
	vpmuludq  896(%rsp),%ymm9,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  704(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1920(%rsp)
	vpaddq    1440(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1440(%rsp)

	vpmuludq  928(%rsp),%ymm9,%ymm1
	vpmuludq  896(%rsp),%ymm10,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  736(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1952(%rsp)
	vpaddq    1472(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1472(%rsp)

	vpmuludq  928(%rsp),%ymm10,%ymm1
	vpmuludq  896(%rsp),%ymm11,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  768(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,1984(%rsp)
	vpaddq    1504(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1504(%rsp)

	vpmuludq  928(%rsp),%ymm11,%ymm1
	vpmuludq  896(%rsp),%ymm12,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  800(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2016(%rsp)
	vpaddq    1536(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1536(%rsp)

	vpmuludq  928(%rsp),%ymm12,%ymm1
	vpmuludq  896(%rsp),%ymm13,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  832(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2048(%rsp)
	vpaddq    1568(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1568(%rsp)

	vpmuludq  928(%rsp),%ymm13,%ymm1
	vpmuludq  896(%rsp),%ymm14,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vpmuludq  864(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2080(%rsp)
	vpaddq    1600(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1600(%rsp)

	vpmuludq  928(%rsp),%ymm14,%ymm1
	vpmuludq  896(%rsp),%ymm15,%ymm0
	vpaddq    %ymm0,%ymm1,%ymm1
	vmovdqa   %ymm1,2112(%rsp)
	vpaddq    1632(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1632(%rsp)

	vpmuludq  928(%rsp),%ymm15,%ymm1
	vmovdqa   %ymm1,2144(%rsp)
	vpaddq    1664(%rsp),%ymm1,%ymm1
	vmovdqa   %ymm1,1664(%rsp)

	vpaddq    640(%rsp),%ymm8,%ymm8
	vpaddq    672(%rsp),%ymm9,%ymm9
	vpaddq    %ymm2,%ymm10,%ymm10
	vpaddq    %ymm3,%ymm11,%ymm11
	vpaddq    %ymm4,%ymm12,%ymm12
	vpaddq    %ymm5,%ymm13,%ymm13
	vpaddq    %ymm6,%ymm14,%ymm14
	vpaddq    %ymm7,%ymm15,%ymm15

	vmovdqa   %ymm14,2176(%rsp)
	vmovdqa   %ymm15,2208(%rsp)

	vmovdqa   704(%rsp),%ymm0
	vmovdqa   736(%rsp),%ymm1
	vmovdqa   768(%rsp),%ymm2
	vmovdqa   800(%rsp),%ymm3
	vmovdqa   832(%rsp),%ymm4
	vmovdqa   864(%rsp),%ymm5
	vmovdqa   896(%rsp),%ymm6
	vmovdqa   928(%rsp),%ymm7

	vpaddq    960(%rsp),%ymm0,%ymm0
	vpaddq    992(%rsp),%ymm1,%ymm1
	vpaddq    1024(%rsp),%ymm2,%ymm2
	vpaddq    1056(%rsp),%ymm3,%ymm3
	vpaddq    1088(%rsp),%ymm4,%ymm4
	vpaddq    1120(%rsp),%ymm5,%ymm5
	vpaddq    1152(%rsp),%ymm6,%ymm6
	vpaddq    1184(%rsp),%ymm7,%ymm7

	vpmuludq  %ymm8,%ymm0,%ymm15
	vmovdqa   %ymm15,2240(%rsp)

	vpmuludq  %ymm9,%ymm0,%ymm15
	vpmuludq  %ymm8,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2272(%rsp)

	vpmuludq  %ymm10,%ymm0,%ymm15
	vpmuludq  %ymm9,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2304(%rsp)

	vpmuludq  %ymm11,%ymm0,%ymm15
	vpmuludq  %ymm10,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2336(%rsp)

	vpmuludq  %ymm12,%ymm0,%ymm15
	vpmuludq  %ymm11,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2368(%rsp)

	vpmuludq  %ymm13,%ymm0,%ymm15
	vpmuludq  %ymm12,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2400(%rsp)

	vpmuludq  2176(%rsp),%ymm0,%ymm15
	vpmuludq  %ymm13,%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vmovdqa   %ymm15,2432(%rsp)

	vpmuludq  2208(%rsp),%ymm0,%ymm15
	vpmuludq  2176(%rsp),%ymm1,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm8,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm8

	vpmuludq  2208(%rsp),%ymm1,%ymm15
	vpmuludq  2176(%rsp),%ymm2,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm9,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm9

	vpmuludq  2208(%rsp),%ymm2,%ymm15
	vpmuludq  2176(%rsp),%ymm3,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm10,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm10

	vpmuludq  2208(%rsp),%ymm3,%ymm15
	vpmuludq  2176(%rsp),%ymm4,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm11,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm11

	vpmuludq  2208(%rsp),%ymm4,%ymm15
	vpmuludq  2176(%rsp),%ymm5,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm12,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm12

	vpmuludq  2208(%rsp),%ymm5,%ymm15
	vpmuludq  2176(%rsp),%ymm6,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm15
	vpmuludq  %ymm13,%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm13

	vpmuludq  2208(%rsp),%ymm6,%ymm15
	vpmuludq  2176(%rsp),%ymm7,%ymm14
	vpaddq    %ymm14,%ymm15,%ymm14

	vpmuludq  2208(%rsp),%ymm7,%ymm15

	vmovdqa   2240(%rsp),%ymm0
	vmovdqa   2272(%rsp),%ymm1
	vmovdqa   2304(%rsp),%ymm2
	vmovdqa   2336(%rsp),%ymm3
	vmovdqa   2368(%rsp),%ymm4
	vmovdqa   2400(%rsp),%ymm5
	vmovdqa   2432(%rsp),%ymm6

	vpsubq    1696(%rsp),%ymm0,%ymm0
	vpsubq    1728(%rsp),%ymm1,%ymm1
	vpsubq    1760(%rsp),%ymm2,%ymm2
	vpsubq    1792(%rsp),%ymm3,%ymm3
	vpsubq    1824(%rsp),%ymm4,%ymm4
	vpsubq    1856(%rsp),%ymm5,%ymm5
	vpsubq    1888(%rsp),%ymm6,%ymm6
	vpsubq    1920(%rsp),%ymm8,%ymm8
	vpsubq    1952(%rsp),%ymm9,%ymm9
	vpsubq    1984(%rsp),%ymm10,%ymm10
	vpsubq    2016(%rsp),%ymm11,%ymm11
	vpsubq    2048(%rsp),%ymm12,%ymm12
	vpsubq    2080(%rsp),%ymm13,%ymm13
	vpsubq    2112(%rsp),%ymm14,%ymm14
	vpsubq    2144(%rsp),%ymm15,%ymm15

	vpaddq    1472(%rsp),%ymm0,%ymm0
	vpaddq    1504(%rsp),%ymm1,%ymm1
	vpaddq    1536(%rsp),%ymm2,%ymm2
	vpaddq    1568(%rsp),%ymm3,%ymm3
	vpaddq    1600(%rsp),%ymm4,%ymm4
	vpaddq    1632(%rsp),%ymm5,%ymm5
	vpaddq    1664(%rsp),%ymm6,%ymm6

	vpaddq    %ymm9,%ymm0,%ymm0
	vpaddq    %ymm10,%ymm1,%ymm1
	vpaddq    %ymm11,%ymm2,%ymm2
	vpaddq    %ymm12,%ymm3,%ymm3
	vpaddq    %ymm13,%ymm4,%ymm4
	vpaddq    %ymm14,%ymm5,%ymm5
	vpaddq    %ymm15,%ymm6,%ymm6

	vpaddq    1216(%rsp),%ymm9,%ymm9
	vpaddq    1248(%rsp),%ymm10,%ymm10
	vpaddq    1280(%rsp),%ymm11,%ymm11
	vpaddq    1312(%rsp),%ymm12,%ymm12
	vpaddq    1344(%rsp),%ymm13,%ymm13
	vpaddq    1376(%rsp),%ymm14,%ymm14
	vpaddq    1408(%rsp),%ymm15,%ymm15

	vmovdqa   %ymm8,64(%rsp)

	vpsrlq    $28,%ymm9,%ymm7
	vpaddq    %ymm7,%ymm10,%ymm10
	vpand     vecmask28(%rip),%ymm9,%ymm8

	vpsrlq    $28,%ymm0,%ymm7
	vpaddq    %ymm7,%ymm1,%ymm1
	vpand     vecmask28(%rip),%ymm0,%ymm0

	vpsrlq    $28,%ymm10,%ymm7
	vpaddq    %ymm7,%ymm11,%ymm11
	vpand     vecmask28(%rip),%ymm10,%ymm9

	vpsrlq    $28,%ymm1,%ymm7
	vpaddq    %ymm7,%ymm2,%ymm2
	vpand     vecmask28(%rip),%ymm1,%ymm1

	vpsrlq    $28,%ymm11,%ymm7
	vpaddq    %ymm7,%ymm12,%ymm12
	vpand     vecmask28(%rip),%ymm11,%ymm10

	vpsrlq    $28,%ymm2,%ymm7
	vpaddq    %ymm7,%ymm3,%ymm3
	vpand     vecmask28(%rip),%ymm2,%ymm2

	vpsrlq    $28,%ymm12,%ymm7
	vpaddq    %ymm7,%ymm13,%ymm13
	vpand     vecmask28(%rip),%ymm12,%ymm11

	vpsrlq    $28,%ymm3,%ymm7
	vpaddq    %ymm7,%ymm4,%ymm4
	vpand     vecmask28(%rip),%ymm3,%ymm3

	vpsrlq    $28,%ymm13,%ymm7
	vpaddq    %ymm7,%ymm14,%ymm14
	vpand     vecmask28(%rip),%ymm13,%ymm12

	vpsrlq    $28,%ymm4,%ymm7
	vpaddq    %ymm7,%ymm5,%ymm5
	vpand     vecmask28(%rip),%ymm4,%ymm4

	vpsrlq    $28,%ymm14,%ymm7
	vpaddq    %ymm7,%ymm15,%ymm15
	vpand     vecmask28(%rip),%ymm14,%ymm13

	vpsrlq    $28,%ymm5,%ymm7
	vpaddq    %ymm7,%ymm6,%ymm6
	vpand     vecmask28(%rip),%ymm5,%ymm5

	vmovdqa   %ymm10,96(%rsp)
	vpsrlq    $28,%ymm15,%ymm10
	vpaddq    1440(%rsp),%ymm10,%ymm10
	vpand     vecmask28(%rip),%ymm15,%ymm14

	vpsrlq    $28,%ymm6,%ymm7
	vpaddq    64(%rsp),%ymm7,%ymm7
	vpand     vecmask28(%rip),%ymm6,%ymm6

	vmovdqa   %ymm11,128(%rsp)
	vpsrlq    $28,%ymm10,%ymm11
	vpaddq    %ymm11,%ymm0,%ymm0
	vpand     vecmask28(%rip),%ymm10,%ymm15

	vpsrlq    $28,%ymm7,%ymm11
	vpaddq    %ymm11,%ymm8,%ymm8
	vpaddq    %ymm11,%ymm0,%ymm0
	vpand     vecmask28(%rip),%ymm7,%ymm7

	vpsrlq    $28,%ymm8,%ymm11
	vpaddq    %ymm11,%ymm9,%ymm9
	vpand     vecmask28(%rip),%ymm8,%ymm8

	vpsrlq    $28,%ymm0,%ymm11
	vpaddq    %ymm11,%ymm1,%ymm1
	vpand     vecmask28(%rip),%ymm0,%ymm0

	vmovdqa   96(%rsp),%ymm10
	vmovdqa   128(%rsp),%ymm11

	// <T17',T18',X3',Z3'> ← Pack-N2D(<T17,T18,X3,Z3>)
	vpsllq    $32,%ymm0,%ymm0
	vpor      %ymm0,%ymm8,%ymm8
	vpsllq    $32,%ymm1,%ymm1
	vpor      %ymm1,%ymm9,%ymm9
	vpsllq    $32,%ymm2,%ymm2
	vpor      %ymm2,%ymm10,%ymm10
	vpsllq    $32,%ymm3,%ymm3
	vpor      %ymm3,%ymm11,%ymm11
	vpsllq    $32,%ymm4,%ymm4
	vpor      %ymm4,%ymm12,%ymm12
	vpsllq    $32,%ymm5,%ymm5
	vpor      %ymm5,%ymm13,%ymm13
	vpsllq    $32,%ymm6,%ymm6
	vpor      %ymm6,%ymm14,%ymm14
	vpsllq    $32,%ymm7,%ymm7
	vpor      %ymm7,%ymm15,%ymm15

	// <T19',*,*,*> ← Dense-Add(<T17',T18',X3',Z3'>,<T17',T18',X3',Z3'>)
	vpaddd	  %ymm8,%ymm8,%ymm0
	vpaddd	  %ymm9,%ymm9,%ymm1
	vpaddd	  %ymm10,%ymm10,%ymm2
	vpaddd	  %ymm11,%ymm11,%ymm3
	vpaddd	  %ymm12,%ymm12,%ymm4
	vpaddd	  %ymm13,%ymm13,%ymm5
	vpaddd	  %ymm14,%ymm14,%ymm6
	vpaddd	  %ymm15,%ymm15,%ymm7

	// <*,T19',*,*> ← Dense-Shuffle(<T19',*,*,*>)
	vpshufd   $78,%ymm0,%ymm0
	vpshufd   $78,%ymm1,%ymm1
	vpshufd   $78,%ymm2,%ymm2
	vpshufd   $78,%ymm3,%ymm3
	vpshufd   $78,%ymm4,%ymm4
	vpshufd   $78,%ymm5,%ymm5
	vpshufd   $78,%ymm6,%ymm6
	vpshufd   $78,%ymm7,%ymm7

	// <*,Z2',*,*> ← Dense-Add(<T17',T18',X3',Z3'>,<*,T19',*,*>)
	vpaddd	  %ymm8,%ymm0,%ymm0
	vpaddd	  %ymm9,%ymm1,%ymm1
	vpaddd	  %ymm10,%ymm2,%ymm2
	vpaddd	  %ymm11,%ymm3,%ymm3
	vpaddd	  %ymm12,%ymm4,%ymm4
	vpaddd	  %ymm13,%ymm5,%ymm5
	vpaddd	  %ymm14,%ymm6,%ymm6
	vpaddd	  %ymm15,%ymm7,%ymm7

	// <X2',Z2',*,*> ← Dense-Blend(<X2',*,*,*>,<*,Z2',*,*>,0100)
	vpblendd  $3,2464(%rsp),%ymm0,%ymm0
	vpblendd  $3,2496(%rsp),%ymm1,%ymm1
	vpblendd  $3,2528(%rsp),%ymm2,%ymm2
	vpblendd  $3,2560(%rsp),%ymm3,%ymm3
	vpblendd  $3,2592(%rsp),%ymm4,%ymm4
	vpblendd  $3,2624(%rsp),%ymm5,%ymm5
	vpblendd  $3,2656(%rsp),%ymm6,%ymm6
	vpblendd  $3,2688(%rsp),%ymm7,%ymm7

	// <X2',Z2',X3',Z3'> ← Dense-Blend(<X2',Z2',*,*>,<T17',T18',X3',Z3'>,0011)
	vpblendd  $15,%ymm0,%ymm8,%ymm8
	vpblendd  $15,%ymm1,%ymm9,%ymm9
	vpblendd  $15,%ymm2,%ymm10,%ymm10
	vpblendd  $15,%ymm3,%ymm11,%ymm11
	vpblendd  $15,%ymm4,%ymm12,%ymm12
	vpblendd  $15,%ymm5,%ymm13,%ymm13
	vpblendd  $15,%ymm6,%ymm14,%ymm14
	vpblendd  $15,%ymm7,%ymm15,%ymm15

	subb      $1,%cl
	cmpb	  $0,%cl
	jge       .L2

	movb	  $7,%cl
	subq      $1,%r15
	cmpq	  $0,%r15
	jge       .L1

	// <X2,Z2,X3,Z3> ← Pack-D2N(<X2',Z2',X3',Z3'>)
	vpsrlq    $32,%ymm8,%ymm0
	vpand     vecmask32(%rip),%ymm8,%ymm8
	vpsrlq    $32,%ymm9,%ymm1
	vpand     vecmask32(%rip),%ymm9,%ymm9
	vpsrlq    $32,%ymm10,%ymm2
	vpand     vecmask32(%rip),%ymm10,%ymm10
	vpsrlq    $32,%ymm11,%ymm3
	vpand     vecmask32(%rip),%ymm11,%ymm11
	vpsrlq    $32,%ymm12,%ymm4
	vpand     vecmask32(%rip),%ymm12,%ymm12
	vpsrlq    $32,%ymm13,%ymm5
	vpand     vecmask32(%rip),%ymm13,%ymm13
	vpsrlq    $32,%ymm14,%ymm6
	vpand     vecmask32(%rip),%ymm14,%ymm14
	vpsrlq    $32,%ymm15,%ymm7
	vpand     vecmask32(%rip),%ymm15,%ymm15

	// <X2,Z2,X3,Z3> ← Reduce(<X2,Z2,X3,Z3>)
	vmovdqa   %ymm7,64(%rsp)

	vpsrlq    $28,%ymm8,%ymm7
	vpaddq    %ymm7,%ymm9,%ymm9
	vpand     vecmask28(%rip),%ymm8,%ymm8

	vmovdqa   %ymm8,96(%rsp)

	vpsrlq    $28,%ymm9,%ymm7
	vpaddq    %ymm7,%ymm10,%ymm10
	vpand     vecmask28(%rip),%ymm9,%ymm9

	vmovdqa   %ymm9,128(%rsp)

	vpsrlq    $28,%ymm10,%ymm7
	vpaddq    %ymm7,%ymm11,%ymm11
	vpand     vecmask28(%rip),%ymm10,%ymm10

	vmovdqa   %ymm10,160(%rsp)

	vpsrlq    $28,%ymm11,%ymm7
	vpaddq    %ymm7,%ymm12,%ymm12
	vpand     vecmask28(%rip),%ymm11,%ymm11

	vpsrlq    $28,%ymm12,%ymm7
	vpaddq    %ymm7,%ymm13,%ymm13
	vpand     vecmask28(%rip),%ymm12,%ymm12

	vpsrlq    $28,%ymm13,%ymm7
	vpaddq    %ymm7,%ymm14,%ymm14
	vpand     vecmask28(%rip),%ymm13,%ymm13

	vpsrlq    $28,%ymm14,%ymm7
	vpaddq    %ymm7,%ymm15,%ymm15
	vpand     vecmask28(%rip),%ymm14,%ymm14

	vpsrlq    $28,%ymm15,%ymm7
	vpaddq    %ymm7,%ymm0,%ymm0
	vpand     vecmask28(%rip),%ymm15,%ymm15

	vpsrlq    $28,%ymm0,%ymm7
	vpaddq    %ymm7,%ymm1,%ymm1
	vpand     vecmask28(%rip),%ymm0,%ymm0

	vpsrlq    $28,%ymm1,%ymm7
	vpaddq    %ymm7,%ymm2,%ymm2
	vpand     vecmask28(%rip),%ymm1,%ymm1

	vpsrlq    $28,%ymm2,%ymm7
	vpaddq    %ymm7,%ymm3,%ymm3
	vpand     vecmask28(%rip),%ymm2,%ymm2

	vpsrlq    $28,%ymm3,%ymm7
	vpaddq    %ymm7,%ymm4,%ymm4
	vpand     vecmask28(%rip),%ymm3,%ymm3

	vpsrlq    $28,%ymm4,%ymm7
	vpaddq    %ymm7,%ymm5,%ymm5
	vpand     vecmask28(%rip),%ymm4,%ymm4

	vpsrlq    $28,%ymm5,%ymm7
	vpaddq    %ymm7,%ymm6,%ymm6
	vpand     vecmask28(%rip),%ymm5,%ymm5

	vpsrlq    $28,%ymm6,%ymm7
	vpaddq    64(%rsp),%ymm7,%ymm7
	vpand     vecmask28(%rip),%ymm6,%ymm6

	vpsrlq    $28,%ymm7,%ymm8
	vpaddq    %ymm8,%ymm0,%ymm0
	vpaddq    96(%rsp),%ymm8,%ymm8
	vpand     vecmask28(%rip),%ymm7,%ymm7

	vpsrlq    $28,%ymm8,%ymm9
	vpaddq    128(%rsp),%ymm9,%ymm9
	vpand     vecmask28(%rip),%ymm8,%ymm8

	vpsrlq    $28,%ymm0,%ymm10
	vpaddq    %ymm10,%ymm1,%ymm1
	vpand     vecmask28(%rip),%ymm0,%ymm0

	vmovdqa   160(%rsp),%ymm10

	// store <X2,Z2,X3,Z3>
	vmovdqa   %ymm8,0(%rdi)
	vmovdqa   %ymm9,32(%rdi)
	vmovdqa   %ymm10,64(%rdi)
	vmovdqa   %ymm11,96(%rdi)
	vmovdqa   %ymm12,128(%rdi)
	vmovdqa   %ymm13,160(%rdi)
	vmovdqa   %ymm14,192(%rdi)
	vmovdqa   %ymm15,224(%rdi)
	vmovdqa   %ymm0,256(%rdi)
	vmovdqa   %ymm1,288(%rdi)
	vmovdqa   %ymm2,320(%rdi)
	vmovdqa   %ymm3,352(%rdi)
	vmovdqa   %ymm4,384(%rdi)
	vmovdqa   %ymm5,416(%rdi)
	vmovdqa   %ymm6,448(%rdi)
	vmovdqa   %ymm7,480(%rdi)

	movq 	  0(%rsp),%r11
	movq 	  8(%rsp),%r12
	movq 	  16(%rsp),%r13
	movq 	  24(%rsp),%r14
	movq 	  32(%rsp),%r15
	movq 	  40(%rsp),%rbx
	movq 	  48(%rsp),%rbp

	movq 	  %r11,%rsp

	ret
