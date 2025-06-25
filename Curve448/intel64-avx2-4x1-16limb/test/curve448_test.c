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

#include <stdio.h>
#include <math.h>
#include "curve448.h"
#include "basic_types.h"
#include "gf_p4482241_type.h"
#include "gf_p4482241_arith.h"

#define FILE stdout

#include "cpucycles.h"
#define TIMINGS 12345
static long long t[TIMINGS+1];

static void print_median_cycles(void) {

	long long median = 0;

	for (long long i = 0;i < TIMINGS;++i)
    		t[i] = t[i+1]-t[i];
  	for (long long j = 0;j < TIMINGS;++j) {
    		long long belowj = 0;
    		long long abovej = 0;
    		for (long long i = 0;i < TIMINGS;++i) if (t[i] < t[j]) ++belowj;
    		for (long long i = 0;i < TIMINGS;++i) if (t[i] > t[j]) ++abovej;
    		if (belowj*2 < TIMINGS && abovej*2 < TIMINGS) {
      			median = t[j];
      			break;
    		}
  	}
  	printf("%lld\n\n",median);
  	fflush(stdout);
}

int main() {

	uchar8 n[CRYPTO_BYTES] = {102, 66, 236, 240, 6, 149, 92, 7, 43, 107, 163, 255, 64, 145, 5, 203, 230, 54, 147, 234, 197, 5, 215, 214, 124, 189, 226, 219, 235, 71, 20, 20,102, 66, 236, 240, 6, 149, 92, 7, 43, 107, 163, 255, 64, 145, 5, 203, 230, 54, 147, 234, 197, 5, 215, 255};
	uchar8 p[CRYPTO_BYTES] = {5};
	uchar8 q[CRYPTO_BYTES];

	uchar8 i;

	curve448_scalarmult(q,n,p);

	fprintf(FILE,"\n");
	for(i=0;i<CRYPTO_BYTES;++i) fprintf(FILE,"%4d",p[i]); fprintf(FILE,"\n\n");
	for(i=0;i<CRYPTO_BYTES;++i) fprintf(FILE,"%4d",q[i]); fprintf(FILE,"\n\n");

	curve448_scalarmult_base(q,n,p);

	for(i=0;i<CRYPTO_BYTES;++i) fprintf(FILE,"%4d",p[i]); fprintf(FILE,"\n\n");
	for(i=0;i<CRYPTO_BYTES;++i) fprintf(FILE,"%4d",q[i]); fprintf(FILE,"\n\n");

	fprintf(FILE,"Computing CPU-cycles. It will take some time. Please wait!\n\n");
	
    	for (long long i = 0;i <= TIMINGS;++i) {
      		t[i] = cpucycles();
      		curve448_scalarmult_base(q,n,p);
   	}	
	
	fprintf(FILE,"CPU-cycles for key generation of Curve448: ");
	print_median_cycles();	
	
    	for (long long i = 0;i <= TIMINGS;++i) {
      		t[i] = cpucycles();
      		curve448_scalarmult(q,n,p);
   	}	
	
	fprintf(FILE,"CPU-cycles for key generation of Curve448: ");
	print_median_cycles();
	
	return 0;
}
