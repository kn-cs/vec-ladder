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

#include "basic_types.h"
#include "gf_p25519_type.h"
#include "gf_p25519_arith.h"

/* Routine borrowed from supercop against the work "Sandy2x: New Curve25519 Speed Records" by Tung Chou. 
   Code-link: https://github.com/floodyberry/supercop/blob/master/crypto_scalarmult/curve25519/sandy2x/fe51_invert.c
*/

void gfp25519invx(gfe_p25519_4L *einv, const gfe_p25519_4L *e) {	

	gfe_p25519_4L t,z2,z9,z11,z2_5_0,z2_10_0,z2_20_0,z2_50_0,z2_100_0;

	/* 2  */ gfp25519sqrx(&z2,e);
	/* 4  */ gfp25519sqrx(&t,&z2);
	/* 8  */ gfp25519sqrx(&t,&t);
	/* 9  */ gfp25519mulx(&z9,&t,e);
	/* 11 */ gfp25519mulx(&z11,&z9,&z2);
	/* 22 */ gfp25519sqrx(&t,&z11);

	/* 2^5 - 1       */ gfp25519mulx(&z2_5_0,&t,&z9);

	/* 2^10 - 2^5    */ gfp25519nsqrx(&t,&z2_5_0, 5);
	/* 2^10 - 1      */ gfp25519mulx(&z2_10_0,&t,&z2_5_0); 

	/* 2^20 - 2^10   */ gfp25519nsqrx(&t,&z2_10_0, 10);
	/* 2^20 - 1      */ gfp25519mulx(&z2_20_0,&t,&z2_10_0);

	/* 2^40 - 2^20   */ gfp25519nsqrx(&t,&z2_20_0, 20);
	/* 2^40 - 1      */ gfp25519mulx(&t,&t,&z2_20_0);

	/* 2^50 - 2^10   */ gfp25519nsqrx(&t,&t,10);
	/* 2^50 - 1      */ gfp25519mulx(&z2_50_0,&t,&z2_10_0);

	/* 2^100 - 2^50  */ gfp25519nsqrx(&t,&z2_50_0, 50);
	/* 2^100 - 1     */ gfp25519mulx(&z2_100_0,&t,&z2_50_0);

	/* 2^200 - 2^100 */ gfp25519nsqrx(&t,&z2_100_0, 100);
	/* 2^200 - 1     */ gfp25519mulx(&t,&t,&z2_100_0);

	/* 2^250 - 2^50  */ gfp25519nsqrx(&t,&t, 50);
	/* 2^250 - 1     */ gfp25519mulx(&t,&t,&z2_50_0);

	/* 2^255 - 2^5   */ gfp25519nsqrx(&t,&t,5); 
	/* 2^255 - 21    */ gfp25519mulx(einv,&t,&z11);
}


void gfp25519inv(gfe_p25519_5L *einv, const gfe_p25519_5L *e) {	

	gfe_p25519_5L t,z2,z9,z11,z2_5_0,z2_10_0,z2_20_0,z2_50_0,z2_100_0;

	/* 2  */ gfp25519sqr(&z2,e);
	/* 4  */ gfp25519sqr(&t,&z2);
	/* 8  */ gfp25519sqr(&t,&t);
	/* 9  */ gfp25519mul(&z9,&t,e);
	/* 11 */ gfp25519mul(&z11,&z9,&z2);
	/* 22 */ gfp25519sqr(&t,&z11);

	/* 2^5 - 1       */ gfp25519mul(&z2_5_0,&t,&z9);

	/* 2^10 - 2^5    */ gfp25519nsqr(&t,&z2_5_0, 5);
	/* 2^10 - 1      */ gfp25519mul(&z2_10_0,&t,&z2_5_0); 

	/* 2^20 - 2^10   */ gfp25519nsqr(&t,&z2_10_0, 10);
	/* 2^20 - 1      */ gfp25519mul(&z2_20_0,&t,&z2_10_0);

	/* 2^40 - 2^20   */ gfp25519nsqr(&t,&z2_20_0, 20);
	/* 2^40 - 1      */ gfp25519mul(&t,&t,&z2_20_0);

	/* 2^50 - 2^10   */ gfp25519nsqr(&t,&t,10);
	/* 2^50 - 1      */ gfp25519mul(&z2_50_0,&t,&z2_10_0);

	/* 2^100 - 2^50  */ gfp25519nsqr(&t,&z2_50_0, 50);
	/* 2^100 - 1     */ gfp25519mul(&z2_100_0,&t,&z2_50_0);

	/* 2^200 - 2^100 */ gfp25519nsqr(&t,&z2_100_0, 100);
	/* 2^200 - 1     */ gfp25519mul(&t,&t,&z2_100_0);

	/* 2^250 - 2^50  */ gfp25519nsqr(&t,&t, 50);
	/* 2^250 - 1     */ gfp25519mul(&t,&t,&z2_50_0);

	/* 2^255 - 2^5   */ gfp25519nsqr(&t,&t,5); 
	/* 2^255 - 21    */ gfp25519mul(einv,&t,&z11);
}
