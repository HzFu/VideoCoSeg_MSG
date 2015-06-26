function [ Color_hist ] = MSG_ColorHist( frame, mask, para )
% Compute the frame color histogram

    [L,a,b] = RGB2Lab(double(frame(:,:,1)), double(frame(:,:,2)), double(frame(:,:,3)));
    
    if(max(L(:)) > 100 || min(L(:)) < 0)
        fprintf('error in L range\n');
        keyboard;
    end
    if(max(a(:)) > 128 || min(a(:)) < -128)
        fprintf('error in a range\n');
        keyboard;
    end
    if(max(b(:)) > 128 || min(b(:)) < -128)
        fprintf('error in b range\n');
        keyboard;
    end 
    
    Color_hist = [histc(L(mask>0), para.LBinEdges); ...
        histc(a(mask>0), para.abBinEdges); histc(b(mask>0), para.abBinEdges)];
    Color_hist = Color_hist';
end

