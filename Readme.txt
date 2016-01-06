The Matlab code for Object-based Multiple Foreground Video Co-segmentation

The project page: http://hzfu.github.io/subpage/video_coseg/video_coseg.html
--------------------------------------------------------------------------------
Please cite the following publication if you used or was inspired by this code/work:

[1] Huazhu Fu, Dong Xu, Bao Zhang, Stephen Lin, 
"Object-based Multiple Foreground Video Co-segmentation", 
in IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2014, pp. 3166-3173.

[2] Huazhu Fu, Dong Xu, Bao Zhang, Stephen Lin, Rabab K. Ward, 
"Object-based Multiple Foreground Video Co-segmentation via Multi-state Selection Graph", 
IEEE Transactions on Image Processing (TIP), vol. 24, no. 11, pp. 3415-3424, 2015.

--------------------------------------------------------------------------------
This code is wrote by MATLAB, and it can run under Windows.
If you find any bugs, please contact Huazhu Fu (huazhufu@gmail.com).

--------------------------------------------------------------------------------
Note:

1. Change the file path for your data, and run demo.m.
2. For each video set, please tune the parameters to obtain the best result.
3. We only provide the candidate selection without pixel-level refine processing.
The pixel-level refine processing can employ any existing spatiotemporal segmentation methods.
--------------------------------------------------------------------------------

Acknowledgements

This software requires the following resources, which are already integrated. 
However, any commercial use or redistribution should also be approved by the owners of these resources.

Object Proposal: http://vision.cs.uiuc.edu/proposals/
Co-saliency detection: https://github.com/HzFu/Cosaliency_tip2013/
Optical Flow: http://people.csail.mit.edu/celiu/OpticalFlow/
TRW-S: http://pub.ist.ac.at/~vnk/papers/TRW-S.html/

---------------------------------------------------------------------------------
Update:
2015.6 -- version 1.0
