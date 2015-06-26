function [ MovScore ] = MSG_MovScore( maskpath, optflowpath )
% obtain the motion score 
    load(maskpath, 'mask');
    load(optflowpath, 'u','v');
    
    [mask_H, mask_W, mask_num] = size(mask);
    MovScore = zeros(mask_num , 1);
    bdryPix = 30;
    flowBinEdges = [-15:0.5:15];
    
    for i = 1:mask_num
        BSeg = zeros(mask_H,mask_W);
        temp_m = mask(:,:,i);
        BSeg(temp_m > 0) = 1;
        
        % get bbox region of interest    
        [y,x] = find(BSeg==1);    

        minx = min(x); maxx = max(x); 
        miny = min(y); maxy = max(y);          

        tbdry = max(miny-bdryPix,1);
        bbdry = min(maxy+bdryPix,mask_H);
        lbdry = max(minx-bdryPix,1);
        rbdry = min(maxx+bdryPix,mask_W);

        ROISeg = BSeg(tbdry:bbdry, lbdry:rbdry);
        fg_inds = find(ROISeg==1);
        bg_inds = find(ROISeg==0);
        
        % get fg bg region optical flow histograms    
        ROIvx = u(tbdry:bbdry, lbdry:rbdry); 
        ROIvy = v(tbdry:bbdry, lbdry:rbdry); 
        
        fg_flow_hist = normalizeFeats([histc(ROIvx(fg_inds), flowBinEdges); histc(ROIvy(fg_inds), flowBinEdges)]');
        bg_flow_hist = normalizeFeats([histc(ROIvx(bg_inds), flowBinEdges); histc(ROIvy(bg_inds), flowBinEdges)]');

        flowDist = pdist2(fg_flow_hist,bg_flow_hist,'chisq');        
        flowAffinity = 1 - exp(-flowDist); 
        
        MovScore(i) = flowAffinity;
    end
    
end

