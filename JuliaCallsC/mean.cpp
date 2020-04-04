double vectorMean(int *arr, int n)
{
  int i, sum=0;
  double mean;
  for (i=0; i<n; i=i+1)
    sum = sum + arr[i];
  mean = sum / (double)n;
  return mean;
}
