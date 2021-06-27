#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc,char* argv[]) {
    FILE* fp;
    float user,system,wall_clock,w_min,w_sec;
    int mode;

    if(argc != 3){
        printf("Wrong # of parameters, insert: <filename> <min|sec>\n"); exit(1);
    }
    // Stampa tempo in minuti / secondi
    if(strcmp(argv[2],"min")==0){
        mode=1;
    } else if(strcmp(argv[2],"sec")==0){
        mode=2;
    } else {
        printf("Wrong type of parameters, insert: <filename> <min|sec>\n"); exit(1);
    }

    fp = fopen(argv[1],"r");
    if(fp==NULL){
        printf("File %s does NOT exist\n",argv[1]); exit(1);
    }

    fscanf(fp,"%f %f %f:%f",&user,&system,&w_min,&w_sec);
    wall_clock = w_sec + w_min*60;

    if(mode==1){
        // Tempo in minuti
        printf("User+System_time:%.2f\nWall_clock:%.2f\n",(user+system)/60,wall_clock/60);
    } else {
        // Tempo in secondi
        printf("User+System_time:%.2f\nWall_clock:%.2f\n",user+system,wall_clock);
    }

    return 0;
}
