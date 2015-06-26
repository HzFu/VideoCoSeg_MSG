function [ Saliency_Map_final ] = MSG_Get_cosaliency( para)
%MSG_GET_COSALIENCY Summary of this function goes here
%   Detailed explanation goes here

%% Generate co-saliency map
video_num = numel(para.video_name);
Scale=200; % Scale 
%clustering number on multi-image
Bin_num=10;
%clustering number on single-image
Bin_num_single=6;
Frame_num = zeros(1,video_num);

%% ------ Obtain the co-saliency for multiple images-------------
%----- obtaining the features -----
All_vector = [];
All_DisVector = [];
All_img = [];
for i=1:para.video_num
   files = dir([para.video_path, para.video_name{i}, '/', '*.' para.img_type]);
   Frame_num(i) = numel(files) - 1;
   for j = 1:Frame_num(i)
       img = imread([para.video_path, para.video_name{i}, '/', files(j,1).name]);
       [imvector img DisVector]=GetImVector(img, Scale, Scale,0);
       All_vector=[All_vector; imvector];
       All_DisVector=[All_DisVector; DisVector];
       All_img=[All_img img];
   end
end

Img_num = sum(Frame_num);
% ---- clustering -------
disp('Clustering for co-saliency');
[idx,ctrs] = kmeansPP(All_vector',Bin_num);
idx=idx';
ctrs=ctrs';

%----- clustering idx map ---------
Cluster_Map = reshape(idx, Scale, Scale*Img_num);

disp('Computing the cues');
%----- computing the Contrast cue -------
Sal_weight_co= Gauss_normal(GetSalWeight( ctrs,idx ));
%----- computing the Spatial cue -------
Dis_weight_co= Gauss_normal(GetPositionW( idx, All_DisVector, Scale, Bin_num ));
%----- computing the Corresponding cue -------
co_weight_co= Gauss_normal(GetCoWeight( idx, Scale, Scale ));
 
%----- combining the Co-Saliency cues -----
SaliencyWeight=(Sal_weight_co.*Dis_weight_co.*co_weight_co);

%----- generating the co-saliency map -----
Saliency_Map_co = Cluster2img( Cluster_Map, SaliencyWeight, Bin_num);


%% ------ Obtain the Single-saliency for each image -------------
%----- the detals see the Demo_single.m ----
disp('Clustering for single saliency');
Saliency_Map_single = zeros(size(Saliency_Map_co));
Idx = 1;
for i = 1:para.video_num
    files = dir([para.video_path, para.video_name{i}, '/', '*.' para.img_type]);
    for j=1:Frame_num(i)
        img=imread(strcat(para.video_path, para.video_name{i}, '/', files(j,1).name));
        [imvector img DisVector]=GetImVector(img, Scale, Scale,0);
        [idx,ctrs] = kmeansPP(imvector',Bin_num_single);
        idx=idx'; ctrs=ctrs';
        Cluster_Map = reshape(idx, Scale, Scale);
        Sal_weight=GetSalWeight( ctrs,idx  );
        Dis_weight  = GetPositionW( idx, DisVector, Scale, Bin_num_single );
        Sal_weight= Gauss_normal(Sal_weight);
        Dis_weight= Gauss_normal(Dis_weight); 
        SaliencyWeight_all=(Sal_weight.*Dis_weight);
        Saliency_sig_final = Cluster2img( Cluster_Map, SaliencyWeight_all, Bin_num_single);

        Saliency_Map_single(:,1+(Idx-1)*Scale:Scale+(Idx-1)*Scale)=Saliency_sig_final;
        Idx = Idx + 1;
    end
end

%% ---- output co-saliency map ----- 
% Saliency_Map_final=Saliency_Map_single .* Saliency_Map_co;
Saliency_Map_final=Saliency_Map_single + Saliency_Map_co;
Saliency_Map_final = Gauss_normal(Saliency_Map_final);


Idx = 1;
for i=1:para.video_num
    files = dir([para.video_path, para.video_name{i}, '/', '*.' para.img_type]);
    for j=1:Frame_num(i)
       path=strcat(para.video_path, para.video_name{i}, '/', files(j,1).name);
       im = imread(path);
       [imH imW imC] = size(im);
       cosal = Saliency_Map_final(:, (1 + (Idx-1)*Scale):(Idx*Scale));
       imwrite(imresize(cosal, [imH imW]),[para.temporal_path, para.video_name{i}, '/propregion/' files(j,1).name(1:end-4) '_covid.png'],'png');
       Idx = Idx + 1;
    end
end

end

