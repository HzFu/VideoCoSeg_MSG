/********************************************************************
	created:	2006/08/04
	created:	4:8:2006   19:15
	file base:	bresenham
	file ext:	cpp
	author:		����
	
	purpose:	�����߶ε������˵�,�����м�����е�
*********************************************************************/
#include "bresenham.h"

#ifdef _DEBUG
#include <iostream>
#endif // _DEBUG

// Ϊ��ֹ�������ͣ��Լ�д�ĸ�������
namespace {
  namespace my {
  
    inline int max(int a,int b) { // rather than std::max ...
      return ((a > b) ? a : b);
    }
    inline int abs(int a) {
      return ( (a >= 0) ? a : (-a) );
    }
  } // namespace my

}


int bresenham(int rs, int cs, int re, int ce, int* rr, int* cc)
{
  //
  // [1]�����0<m<1�����θ����˽��⣬�ɴ˿��ܽ��һ��Ĳ��裺
  //
  // 1.��|m|<1ʱ
  //   ���߱�������
  //      _
  //     /  p0   = IncreY*2*Dy - IncreX*Dx                  k = 0
  //    |
  //     \_ pk+1 = pk + (2*Dy*Sx - 2*Dx*Sy)*IncreX*IncreY   k > 0 
  // 
  //   ���У�IncreX - �Լ��Ƶ�������Ŀ������ӣ�����ʱȡ1������-1
  //         IncreY - �Լ��Ƶ�������Ŀ������ӣ�y����ʱȡ1������-1
  //         Sx - ��x�����ϵĲ�����,{1,-1}
  //         Sy - ��y�����ϵĲ�����,{0,IncreY}
  //   �����У�
  //   ��pk < 0��Sy = 0;����Sy = IncreY
  //   ��һ�����������ǣ�xk+Sx, yk+Sy������pk����������ĵݹ�ʽ
  //   ����Dx�Σ��ܹ����Dx+1������ԡ�
  // 
  // 2.��|m|>1ʱ���ɶԳ��ԣ�ֻ�轫1.�����е�x,y��������
  //
  // ע�⣡��
  // x��Ӧ�У�col����y��Ӧ�У�row��!!
  //
  int p = 0;
  int IncreX = 0, IncreY = 0;
  int Sx = 0, Sy = 0;
  int Dx, Dy;
  Dx = ce - cs;
  Dy = re - rs;
#ifdef _DEBUG
  std::cout << "x0 = " << cs << ", "
    << "y0 = " << rs << std::endl;
  std::cout << "x1 = " << ce << ", "
    << "y1 = " << re << std::endl;
  std::cout << "Dx = " << Dx << ", " 
    << "Dy = " << Dy << std::endl;
#endif // _DEBUG

  if (my::abs(Dy) <= my::abs(Dx)) { // |m| <= 1
    if (ce > cs) Sx = 1, IncreX = 1;
    else Sx = -1, IncreX = -1;
    if (re > rs) IncreY = 1;
    else IncreY = -1;
    int totalLen = my::abs(Dx) + 1;

#ifdef _DEBUG
    std::cout << "Sx = " << Sx << std::endl;
    std::cout << "Incre = " << IncreX << std::endl;
    std::cout << std::endl;
#endif // _DEBUG

    for (int i = 0; i < totalLen; ++i ) {
      if (i == 0) {
        *(cc+i) = cs;
        *(rr+i) = rs;
        p = IncreY*2*Dy - IncreX*Dx;
      }
      else { // i > 0
        if (p < 0) Sy = 0;
        else Sy = IncreY;
        *(cc+i) = *(cc+i-1) + Sx;
        *(rr+i) = *(rr+i-1) + Sy;
        p += (2*Dy*Sx - 2*Dx*Sy)*IncreX*IncreY;
      }

#ifdef _DEBUG
      std::cout << "(" << *(cc+i) << ", " << *(rr+i) << ") " << std::endl;
      std::cout << "p = " << p <<  ", " << "Sy = " << Sy << std::endl;
      std::cout << std::endl;
#endif // _DEBUG
    
    }
    return totalLen;
  }
  else { // |m| > 1 :ֻ�跴ת���е�x,y
    return bresenham(cs, rs, ce, re, cc, rr);
  }


}



int bresenham_len(int rs, int cs, int re, int ce)
{
  return my::max(my::abs(re-rs), my::abs(ce-cs)) + 1;
}