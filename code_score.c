//name: Mihaela Sardiu &  Washburn M.
//institution: Stowers Institute for Medical Research

#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>

#define MAX 100000
int i,j;
double sum_total;

struct protein
{
  char gi[100];
  char label[100];
  double number_save[MAX];
  double sum;
  double sum1;
};

typedef struct protein Protein;

//*******************************

//topological score

void calc_score(Protein *P,int col,FILE *output)
{
  double r; double x,y,z;
  int k,l,m; double x1=0.0;int n;

  printf("Here :%lf\n",sum_total);

  for(n=0;n<col;n++)
    {
      //fprintf(output,"%s\t\t",P[n].label);
    }
  printf("\n");

  for(k=0;k<j;k++)
    {
      //fprintf(output,"%s\t",P[k].gi);
      for(l=0;l<i;l++)
	{
	  fprintf(output,"%s\t",P[k].gi);
	  fprintf(output,"%s\t",P[l+1].label); 
	  x=(P[l].sum*P[k].sum1)/sum_total;
          r=P[l].number_save[k]*log(P[l].number_save[k]/x);
	    
	  if(P[l].number_save[k]==0 || x==0 || P[l].sum==0 || P[k].sum1==0)
	    {
	      //fprintf(output,"%lf\t",x1);
	      fprintf(output,"%lf\n",x1);
	    }
	  else{
	    //fprintf(output,"%lf\t",r);
	    fprintf(output,"%lf\n",r);
	  }
	}
      //fprintf(output,"\n");
    }

}
//******************************

void read_file(FILE *input1,FILE *output, Protein *P,int col)
{
  char string[100];
  double number; int k;
  
  i=0; sum_total=0;
  j=0;

  for(k=0;k<col;k++)
    {
      fscanf(input1,"%s",string);
      strcpy(P[k].label,string);
    }

  P[i].sum=0;P[j].sum1=0;
  while(fscanf(input1,"%s", string)!=EOF)
    {
	  strcpy(P[j].gi,string);	  
	  for(i=0;i<col-1;i++)
	    {
	      fscanf(input1,"%lf",&number);
	      P[i].number_save[j]=number;
	      //printf("Here %lf\n",P[i-1].number_save[j]);
	      P[i].sum=P[i].sum+number; //col sum
	      P[j].sum1=P[j].sum1+number;//raw sum
	      sum_total=sum_total+number;
	    }
	j=j+1;
    }
    

  //printf("Here :%lf\n",sum_total);

}

//*****************************

int main(int argc, char * *argv)
{
  int col;

FILE *input1;
FILE *output;

Protein *P;
P=(Protein *)malloc(MAX*sizeof(Protein));


if(argc!=4)
    {
      printf("usage: <input1> <output> <col>\n");
      exit(1);
    }
 
  input1=fopen(argv[1],"r");
  output=fopen(argv[2],"w");
  col=atoi(argv[3]);
 
  read_file(input1,output,P,col);
  calc_score(P,col,output);


  return 0;
}
