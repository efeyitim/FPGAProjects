#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
  int dividend;
  int divisor;
  if(argc != 3)
    {
      printf("Enter only two numbers!\n");
      return -1;
    }
  else
    {
      dividend = atoi(argv[1]);
      divisor = atoi(argv[2]);
    }

  int i = 1;
  int len = 0;
  while(true)
    {
      if(i > dividend)
	{
	  break;
	}
      else
	{
	  i = i << 1;
	  len++;
	}                  
    }

  divisor = divisor << len;
  int res;
  int quotient = 0;
  int remainder = dividend;
  for(; len >= 0; len--)
    {
      res = remainder - divisor;
      if(res > 0)
	{
	  quotient = ~(~quotient<<1);
	  remainder = res;	  
	}
      else
	{
	  quotient = quotient << 1;
	}
      divisor = divisor >> 1;
      printf("ROUND%d\n", len);
      printf("quotient = %d\n", quotient);
      printf("remainder = %d\n", remainder);            
    }
  //printf("quotient = %d\n", quotient);
  //printf("remainder = %d\n", remainder);
  return 0;
}
