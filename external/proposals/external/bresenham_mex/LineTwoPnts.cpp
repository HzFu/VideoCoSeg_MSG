/*
%LINETWOPNTS ����ֱ������ϵ����ɢ�����㣬������������еĵ�
%   [rr, cc] = LineTwoPnts(rs, cs, re, ce)
% ���룺
%   rs,cs:�����С���
%   re,ce:�յ���С���
% �����
%   rr,cc:�߶������е���С���
**/

#include "mex.h"
#include "bresenham.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,
                 const mxArray *prhs[])
{
  int len;  
  double rs, cs, re, ce;
  int *rr, *cc;
  double *prow, *pcol;
  int i;
    
  /* Check for proper number of arguments. */
  if (nrhs != 4 || nlhs > 2) {
    mexErrMsgTxt("Invalid calling method...please type help LineTwoPntsInMat in command for help");
  } 
  rs = mxGetScalar(prhs[0]);
  cs = mxGetScalar(prhs[1]);
  re = mxGetScalar(prhs[2]);
  ce = mxGetScalar(prhs[3]);
  
  /* ��ȡ�����߶εĳ��� */
  len = bresenham_len((int)rs, (int)cs, (int)re, (int)ce);
  rr = (int*)mxCalloc(len, sizeof(int));
  cc = (int*)mxCalloc(len, sizeof(int));
  plhs[0] = mxCreateDoubleMatrix(1, len, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(1, len, mxREAL);
  
  /* ���߶������е� */
  bresenham((int)rs, (int)cs, (int)re, (int)ce, rr, cc);
  
  /* ��ֵ��������� */
  prow = mxGetPr(plhs[0]);
  pcol = mxGetPr(plhs[1]);
  for (i = 0; i < len; ++i) {
    *(prow+i) = (double)(*(rr+i));
    *(pcol+i) = (double)(*(cc+i));
  }
  

}