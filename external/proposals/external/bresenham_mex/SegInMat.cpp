/*
%SegInMat �������ĳ�߶��ϵ�����Ԫ��
% ���÷�ʽ��
% elem = SegInMat(mat, rs, cs, re, ce)
% ���룺
%   mat:ָ���ľ���
%   rs,cs:�����С���
%   re,ce:�յ���С���
% �����
%   elem:�߶������е��ֵ
%
*/
#include "mex.h"
#include "bresenham.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,
                 const mxArray *prhs[])
{
  int len;  
  double rs, cs, re, ce;
  int *rr, *cc;
  double *p;
  int i;
  int row, col;
    
  /* Check for proper number of arguments. */
  if (nrhs != 5 || nlhs > 1) {
    mexErrMsgTxt("SegInMat::Invalid calling method...please type help LineTwoPntsInMat in"                  "command for help\n");
  } 
  rs = mxGetScalar(prhs[1]);
  cs = mxGetScalar(prhs[2]);
  re = mxGetScalar(prhs[3]);
  ce = mxGetScalar(prhs[4]);
  /* ��ȡ�����߶εĳ��� */
  len = bresenham_len((int)rs, (int)cs, (int)re, (int)ce);
  rr = (int*)mxCalloc(len, sizeof(int));
  cc = (int*)mxCalloc(len, sizeof(int));
  
  
  /* ���߶������е� */
  bresenham((int)rs, (int)cs, (int)re, (int)ce, rr, cc);
  
  /* 
   * ����Ӧ���ϵ�ֵ�������.
   * ע�⣡��Matlab�о����д洢���±��1��ʼ��C���±��0��ʼ
   */
  
  int nrow = mxGetM(prhs[0]);
  int ncol = mxGetN(prhs[0]);

  // ע�⣺��������Ƿ��ڷ�Χ��
  if ( rs > nrow || rs < 1
    || re > nrow || re < 1
    || cs > ncol || cs < 1
    || ce > ncol || ce < 1) 
  {
    mexErrMsgTxt("SegInMat::Input point out of range...\n");
  }
  else 
  {
    plhs[0] = mxCreateDoubleMatrix(1, len, mxREAL);
    p = mxGetPr(plhs[0]);
  }

  
  if (mxIsDouble(prhs[0])) {
    double* pmat = (double* )mxGetPr(prhs[0]);
    for (i = 0; i < len; ++i) {
      row = *(rr+i);
      col = *(cc+i);
      *(p+i) = (double)(*(pmat + (col-1)*nrow + row - 1));
    }
    return;
  }
  else {
    mexErrMsgTxt("SegInMat::Only supports double matrix\n" 
      "Try forced casting:\n"
      "SegInMat(double(mat),rs,cs, re,ce)\n"
      "Or use:\n"
      "  [rr,cc] = LineTwoPnts(rs,ce, re,ce);\n"
      "  idx     = sub2ind(rr,cc);\n"
      "  elems   = mat(idx);\n"
      "as alternative.");
  }
  
  

}