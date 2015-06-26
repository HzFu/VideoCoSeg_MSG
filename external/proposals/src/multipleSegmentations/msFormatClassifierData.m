%% Reformat the input data to be used by classifier 
function [data, lab, w] = msFormatClassifierData(features, labels, weights, maxdata)
% concatenate data

nimages = numel(features);

[tmp, nvars] = size(features{1});

% count segments
nseg = 0;
for f = 1:nimages
    nseg = nseg + sum(labels{f}~=0);
end

data = zeros(nseg, nvars);
lab = zeros(nseg, 1);
w = zeros(nseg, 1);

% concatenate data
vc = 0;
for f = 1:nimages
    ind = (labels{f}~=0);
    nind = sum(ind);
    %disp(num2str([f size(labels{f}) size(features{f})]))
    data(vc+1:vc+nind, :) = features{f}(ind, :);    
    lab(vc+1:vc+nind) = labels{f}(ind);
    w(vc+1:vc+nind) = weights{f}(ind); % weight according to area in image
    vc = vc + nind;
end

if vc > maxdata
    rind = randperm(nseg);
    rind = rind(1:maxdata);
    data = data(rind, :);
    lab = lab(rind);
    w = w(rind);
end
w = w / sum(w);