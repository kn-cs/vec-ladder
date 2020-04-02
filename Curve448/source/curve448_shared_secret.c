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

#include "basic_types.h"
#include "gf_p4482241_type.h"
#include "gf_p4482241_pack.h"
#include "gf_p4482241_arith.h"
#include "curve448.h"

void curve448_shared_secret(uchar8 *np, const uchar8 *p, const uchar8 *n) {

	vec r[NLIMBS_VEC] = {0};
	vec t[NLIMBS_VEC] = {0};

	gfe_p4482241_16L u,v;
	gfe_p4482241_7L w,x,z,zinv;

	uchar8 i;

	gfp4482241pack(&u,p);


	t[0][0] = t[0][3] = r[0][2] = 1; 
	
	for (i=0;i<NLIMBS_VEC;++i) {t[i][2] = u.l[i]; r[i][3] = u.l[i];}

	curve448_vladder(t,r,n);

	for (i=0;i<NLIMBS_VEC;++i) {u.l[i] = t[i][0]; v.l[i] = t[i][1];}

	gfp4482241pack167(&x,&u);
	gfp4482241pack167(&z,&v);

	#if defined(__ADX__)

		gfp4482241invx(&zinv,&z);
		gfp4482241mulx(&w,&zinv,&x);
	#else
		gfe_p4482241_8L a,b,c,binv;
	
		gfp4482241pack78(&a,&x); gfp4482241pack78(&b,&z);
		gfp4482241inv(&binv,&b);
		gfp4482241mul(&c,&binv,&a);
		gfp4482241reduce(&c);
		gfp4482241pack87(&w,&c);
	#endif

	gfp4482241makeunique(&w);
	gfp4482241unpack(np,&w);
}
