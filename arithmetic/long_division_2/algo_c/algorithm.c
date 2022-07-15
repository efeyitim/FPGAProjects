#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
  long int dividend;
  long long int divisor;
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

  long long int i = 1;
  long long int len = 0;
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

  len = 32;
  divisor = divisor << len;
  long long int res;
  long long int res1;
  long long int res2;
  long long int quotient = 0;
  long long int remainder = dividend;
  printf("LEN = %lld\n", len);
  for(; len >= 0; len = len - 2)
    {
      res = remainder - divisor;
      res1 = res - divisor;
      res2 = res1 - divisor;
      if (res2 > 0)
	{
	  quotient = ~(~quotient<<1);
	  quotient = ~(~quotient<<1);	  
	  remainder = res2;
	}
      else if(res1 > 0)
	{
	  quotient = ~(~quotient<<1);	  	  
	  quotient = quotient << 1;
	  remainder = res1;
	}
      else if(res > 0)
	{
	  quotient = quotient << 1;
	  quotient = ~(~quotient<<1);
	  remainder = res;	  
	}
      else
	{
	  quotient = quotient << 2;
	}
      divisor = divisor >> 2;
      printf("ROUND%lld\n", len);
      printf("quotient = %lld\n", quotient);
      printf("remainder = %lld\n", remainder);      
    }
  //printf("quotient = %lld\n", quotient);
  //printf("remainder = %lld\n", remainder);
  return 0;
}
