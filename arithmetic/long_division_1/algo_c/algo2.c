#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
  long long int dividend;
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
  long long int quotient = 0;
  long long int remainder = dividend;
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
      printf("ROUND%lld\n", len);
      printf("quotient = %lld\n", quotient);
      printf("remainder = %lld\n", remainder);            
    }
  //printf("quotient = %lld\n", quotient);
  //printf("remainder = %lld\n", remainder);
  return 0;
}
