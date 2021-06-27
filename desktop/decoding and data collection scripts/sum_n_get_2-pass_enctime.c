#include <stdio.h>
#include <stdlib.h>

int main(int argc,char* argv[]) {
    FILE *fp1,*fp2;
    float user1,system1,user2,system2;
    int flag=0;

    if(argc != 3){
        printf("Wrong # of parameters, insert: <filename_1st-pass> <filename_2nd-pass>\n"); exit(1);
    }

    fp1 = fopen(argv[1],"r"); fp2 = fopen(argv[2],"r");
    if(fp1==NULL) flag=1; else if(fp2==NULL) flag=2;
    if(flag>0){
        printf("File %s does NOT exist\n",argv[flag]); exit(1);
    }

    fscanf(fp1,"%f %f",&user1,&system1);
    fscanf(fp2,"%f %f",&user2,&system2);

    // Stampa tempo in minuti
    printf("User+System_total_time:%.2f\n",(user1+system1 + user2+system2)/60);

    return 0;
}
