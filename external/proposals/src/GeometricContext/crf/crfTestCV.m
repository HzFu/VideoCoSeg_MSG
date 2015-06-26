function [vacc, hacc, vcm, hcm, pg] = crfTestCV(imsegs, pvSP, phSP, adjlist, pE, crfw)

ncv = numel(crfw);
nimages = numel(imsegs);

for f = 1:nimages
    disp(num2str(f))
    c = ceil(f/nimages*ncv);    
    pg{f} = crfTestImage(pvSP{f}, phSP{f}, adjlist{f}, pE{f}, crfw{c});
    [tmpvacc2, tmphacc2] = mcmcProcessResult(imsegs(f), pg(f));    
    [tmpvacc1, tmphacc1] = mcmcProcessResult(imsegs(f), {[pvSP{f}(:, 1) repmat(pvSP{f}(:, 2), 1, 5).*phSP{f} pvSP{f}(:, 3)]}); 
    disp([num2str(tmpvacc1) '-->' num2str(tmpvacc2) '   ' num2str(tmphacc1) '-->' num2str(tmphacc2)])
    im = rgb2gray(im2double(imread(['../images/all_images/' imsegs(f).imname])));
    figure(1), displayLabels(imsegs(f), pvSP{f}, im);
    figure(2), displayLabels(imsegs(f), pg{f}, im);    
    drawnow;
    pause(1)
end
[vacc, hacc, vcm, hcm] = mcmcProcessResult(imsegs, pg);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function displayLabels(imsegs, pg, im)
if size(pg, 2)==7
    v2 = pg(:, 1);
    v1 = sum(pg(:, 2:6), 2);
    v3 = pg(:, 7);
else
    v2 = pg(:, 1);
    v1 = pg(:, 2);
    v3 = pg(:, 3);
end
lim = cat(3, v1(imsegs.segimage), v2(imsegs.segimage), v3(imsegs.segimage));
imagesc(lim*0.5 + repmat(im, [1 1 3])*0.5), axis image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pg = crfTestImage(pvSP, phSP, adjlist, pE, crfw)

   
% get f1(y1, y2) = log(P(y1|x)) + log(P(y2|x))
% and f2(y1, y2) = I(y1=y2)*log(P(y1=y2|x)) + I(y1~=y2)*log(P(y1~=y2|x))

npair = size(adjlist, 1);

f1 = zeros(npair, 7, 7);
f2 = zeros(npair, 7, 7);
f3 = zeros(npair, 7, 7);

pg = [pvSP(:, 1)  repmat(pvSP(:, 2), 1, 5).*phSP  pvSP(:, 3)];  
s1 = adjlist(:, 1);
s2 = adjlist(:, 2);   
for k1 = 1:7
    for k2 = 1:7
        f1(:, k1, k2) = log(pg(s1, k1)) + log(pg(s2, k2));
        if k1==k2
            f2(:, k1, k2) = log(pE);
            %f2(:, k1, k2) = log(1);
        else
            f2(:, k1, k2) = log((1-pE)/6);
            %f2(:, k1, k2) = log(0.000001);
        end
    end
end
   
nsp = size(pvSP, 1);
adjmat = zeros(nsp, nsp);
potentials = cell(nsp, nsp);

evidences = 1/7*ones(7, nsp); % exp(crfw(1)*log(pg')); 
%evidences = exp(log(pg'));

for k = 1:numel(s1)
    adjmat(s1(k), s2(k)) = 1;    
    adjmat(s2(k), s1(k)) = 1;    
    potentials{s1(k), s2(k)} = squeeze(exp(f1(k, :, :) + f2(k, :, :) + crfw(3)*f3(k, :, :)));
    potentials{s2(k), s1(k)} = potentials{s1(k), s2(k)}';    
end

% mrf2 = mk_mrf2(adjmat, potentials);
% engine = belprop_mrf2_inf_engine(mrf2);
% engine = enter_soft_evidence(engine, evidences);
% 
% pg = zeros(nsp, 7);
% for s = 1:nsp
%     disp(marginal_nodes(engine, s))
%     pg(s, :) = marginal_nodes(engine, s)';    
% end

[pg, niter] = bp_mrf2_old(adjmat, potentials, evidences, 'max_iter', 50); 
pg = pg';