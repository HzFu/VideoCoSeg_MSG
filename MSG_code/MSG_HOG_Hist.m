function [ HOG_hist ] = MSG_HOG_Hist( framepath, maskpath, para )
%MVCS_HOGHIST Summary of this function goes here
%   Detailed explanation goes here

    frame = im2double(imread(framepath));
    load(maskpath, 'mask');
    
    G = rgb2gray(frame);
    E = edge(G,'canny');
    [GradientX,GradientY] = gradient(double(G));
%     GradientYY = gradient(GradientY);
    Gr = sqrt((GradientX.*GradientX)+(GradientY.*GradientY));
            
    index = GradientX == 0;
    GradientX(index) = 1e-5;
            
    YX = GradientY./GradientX;
    if para.hog_angle == 180, A = ((atan(YX)+(pi/2))*180)/pi; end
    if para.hog_angle == 360, A = ((atan2(GradientY,GradientX)+pi)*180)/pi; end
                                
    [bh, bv] = anna_binMatrix(A, E, Gr, para.hog_angle, para.hog_bin);
    [imH, imW, maskNum] = size(mask);
    HOG_hist = zeros(maskNum, para.NUM_HOG);
    
    for i = 1:maskNum
        BSeg = zeros(imH,imW);
        temp_m = mask(:,:,i);
        BSeg(temp_m > 0) = 1;
        
        % get bbox region of interest    
        [y,x] = find(BSeg==1);    

        minx = min(x); maxx = max(x); 
        miny = min(y); maxy = max(y);
        
        bh_roi = bh(miny:maxy,minx:maxx);
        bv_roi = bv(miny:maxy,minx:maxx);
        HOG_hist(i,:) = anna_phogDescriptor(bh_roi, bv_roi, para.hog_L,  para.hog_bin);
    end

%     HOG_hist = HOG_hist';

end

