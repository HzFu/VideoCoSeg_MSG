function [ norm_feat ] = MSG_GaussRescale( feature )
% Gauss rescale the featured
%     meanScores = mean(feature,1);
%     stdScores = std(feature,1);
%     norm_feat = (feature-meanScores)/stdScores;
    

    [meanScores,stdScores] = normfit(feature);
    norm_feat = normcdf(feature,meanScores,stdScores);

end

