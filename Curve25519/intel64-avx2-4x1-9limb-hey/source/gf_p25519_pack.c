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

#include "gf_p25519_pack.h"

void gfp25519pack(gfe_p25519_9L *v,const uchar8 *u) {

	uchar8 i,j,k,l;
	gfe_p25519_4L t;

	for (i=0;i<NLIMBS;++i) {
	
		j = i*8;
		t.l[i] = (uint64)u[j]; l = 1;
		for (k=1;k<9;++k)
			t.l[i] |= ((uint64)u[j+l++]  << k*8);
	}

	v->l[0] = ((t.l[0] & 0x000000001FFFFFFF));
	v->l[1] = ((t.l[0] & 0x03FFFFFFE0000000) >> 29);
	v->l[2] = ((t.l[0] & 0xFC00000000000000) >> 58) | ((t.l[1] & 0x00000000007FFFFF) <<  6);
	v->l[3] = ((t.l[1] & 0x000FFFFFFF800000) >> 23);
	v->l[4] = ((t.l[1] & 0xFFF0000000000000) >> 52) | ((t.l[2] & 0x000000000001FFFF) << 12);
	v->l[5] = ((t.l[2] & 0x00003FFFFFFE0000) >> 17);
	v->l[6] = ((t.l[2] & 0xFFFFC00000000000) >> 46) | ((t.l[3] & 0x00000000000007FF) << 18);
	v->l[7] = ((t.l[3] & 0x000000FFFFFFF800) >> 11);
	v->l[8] = ((t.l[3] & 0x7FFFFF0000000000) >> 40);
}

void gfp25519pack94(gfe_p25519_4L *v,const gfe_p25519_9L *u) {

        v->l[0] = ((u->l[0] & 0x000000001FFFFFFF))       | ((u->l[1] & 0x000000001FFFFFFF) << 29) | ((u->l[2] & 0x000000000000003F) << 58);
        v->l[1] = ((u->l[2] & 0x000000001FFFFFC0) >>  6) | ((u->l[3] & 0x000000001FFFFFFF) << 23) | ((u->l[4] & 0x0000000000000FFF) << 52);
        v->l[2] = ((u->l[4] & 0x000000001FFFF000) >> 12) | ((u->l[5] & 0x000000001FFFFFFF) << 17) | ((u->l[6] & 0x000000000003FFFF) << 46);
        v->l[3] = ((u->l[6] & 0x000000001FFC0000) >> 18) | ((u->l[7] & 0x000000001FFFFFFF) << 11) | ((u->l[8] & 0x00000000007FFFFF) << 40);   
}

void  gfp25519pack45(gfe_p25519_5L *v, const gfe_p25519_4L *u) {
													
	v->l[0] = ((u->l[0] & 0x0007FFFFFFFFFFFF));
	v->l[1] = ((u->l[0] & 0xFFF8000000000000) >> 51) | ((u->l[1] & 0x0000003FFFFFFFFF) << 13);
	v->l[2] = ((u->l[1] & 0xFFFFFFC000000000) >> 38) | ((u->l[2] & 0x0000000001FFFFFF) << 26);
	v->l[3] = ((u->l[2] & 0xFFFFFFFFFE000000) >> 25) | ((u->l[3] & 0x0000000000000FFF) << 39);
	v->l[4] = ((u->l[3] & 0x7FFFFFFFFFFFF000) >> 12);
}

void  gfp25519pack54(gfe_p25519_4L *v, const gfe_p25519_5L *u) {

	v->l[0] = ((u->l[0] & 0x0007FFFFFFFFFFFF))       | ((u->l[1] & 0x0000000000001FFF) << 51);
	v->l[1] = ((u->l[1] & 0x0007FFFFFFFFE000) >> 13) | ((u->l[2] & 0x0000000003FFFFFF) << 38);
	v->l[2] = ((u->l[2] & 0x0007FFFFFC000000) >> 26) | ((u->l[3] & 0x0000007FFFFFFFFF) << 25);
	v->l[3] = ((u->l[3] & 0x0007FF8000000000) >> 39) | ((u->l[4] & 0x0007FFFFFFFFFFFF) << 12);
}

void gfp25519unpack(uchar8 *v,const gfe_p25519_4L *u) {

	uchar8 i,j;

	for (i=0;i<NLIMBS;++i) {

		j = i*8;
		v[j+0] = (uchar8)((u->l[i] & 0x00000000000000FF));
		v[j+1] = (uchar8)((u->l[i] & 0x000000000000FF00) >>  8);
		v[j+2] = (uchar8)((u->l[i] & 0x0000000000FF0000) >> 16);
		v[j+3] = (uchar8)((u->l[i] & 0x00000000FF000000) >> 24);
		v[j+4] = (uchar8)((u->l[i] & 0x000000FF00000000) >> 32);
		v[j+5] = (uchar8)((u->l[i] & 0x0000FF0000000000) >> 40);
		v[j+6] = (uchar8)((u->l[i] & 0x00FF000000000000) >> 48);
		v[j+7] = (uchar8)((u->l[i] & 0xFF00000000000000) >> 56);
	}
}
