
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int main(int argc, char **argv) {
	if (argc!=6) {
		printf("Use:  %s file1.yuv file2.yuv w h framenum\n",argv[0]); exit(1);
	}
	FILE *f1;
	FILE *f2;
	if ((f1=fopen(argv[1],"rb"))==NULL) { printf("Error opening file\n"); exit(1); }
	if ((f2=fopen(argv[2],"rb"))==NULL) { printf("Error opening file\n"); exit(1); }
	int w=atoi(argv[3]);
	int h=atoi(argv[4]);
	int frnum=atoi(argv[5]);
	int frsize=w*h+w*h/2;
	
	unsigned char *buf1=(unsigned char *)malloc(sizeof(unsigned char)*w);
	if (buf1==NULL) { printf("Not enough memory\n"); exit(1); }
	unsigned char *buf2=(unsigned char *)malloc(sizeof(unsigned char)*w);
	if (buf2==NULL) { printf("Not enough memory\n"); exit(1); }

	double cum_psnr=0.0;
	int fr;
	int j,i;
	for (fr=0; fr<frnum; fr++) {
		fseek(f1, fr*frsize, SEEK_SET);
		fseek(f2, fr*frsize, SEEK_SET);
		double msetot=0.0;
		int cnt=0;
		for (j=0; j<h; j++) {
			fread(buf1, w, 1, f1);
			fread(buf2, w, 1, f2);
			for (i=0; i<w; i++) {
				int v1 = (unsigned int)(unsigned char)buf1[i];
				int v2 = (unsigned int)(unsigned char)buf2[i];
				msetot += (double) (v1-v2)*(v1-v2);
				cnt++;
			}
		}	
		double mse=msetot/cnt;
		double psnr=10.0*log10(255.0*255.0/mse);
		cum_psnr+=psnr;
	}
	double seq_psnr=cum_psnr/fr;
	printf("%.2f\n",seq_psnr);

	free(buf1);
	free(buf2);
	fclose(f1);
	fclose(f2);
	return 0;
}

