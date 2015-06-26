/********************************************************************
	created:	2006/08/04
	created:	4:8:2006   19:04
	file ext:	h
	author:		����
	
	purpose:	�����߶ε������˵�,�����м�����е�
            �㷨�μ�[1]
*********************************************************************/
#ifndef bresenham_H_
#define bresenham_H_



 
#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

// ���������ϵ����С���ԡ�
// rs,cs,re,ce:���(sTART)����,���Լ��յ�(eND)����,��
// *rr,*cc:�߶������е���С���
// ����������������㹻�Ŀռ�
// �����ɹ����ص�ĸ�����ʧ�ܷ���-1
// ע�⣡��
// row��Ӧy, col��Ӧx.
int bresenham (int rs, int cs, int re, int ce, int* rr, int* cc);

// �������������С���ԡ��ĸ���
// rs,cs,re,ce:���(sTART)����,���Լ��յ�(eND)����,��
// ���ص�Եĸ���
// ע�⣡��
// row��Ӧy, col��Ӧx.
int bresenham_len (int rs, int cs, int re, int ce);

#ifdef __cplusplus
}
#endif // __cplusplus


// �ο�����
//[1]�������ͼ��ѧ����Donald Hearn�� �� ��ʿ�ܵ� �룬���������ӹ�ҵ������
//    p.p. 45~49
#endif // bresenham_H_