% This file is written to conduct our algorithm in experiment B
%% 
clear;
clc;
close all;
%% 
M = 20; N=64; L = 100; K = 4; lambda = 0.9; 

blkSize = 8; mblk_I = 8; nblk_I = mblk_I;
%% train the dictionary by online algorithm.
epoch = 5; Batchsize = 256; mode_A=false; mode_B = true; mode_C = true;
Isini = false; Iter_dic = 1; Percent = 0.005; Iter_unused = 1000;
param = struct('epsilon',1e-6,'K',L,'lambda',K,'epoch',epoch,'Batchsize',Batchsize...
    ,'mode_A',mode_A,'mode_B',mode_B,'mode_C',mode_C,...
    'Isini',Isini,'Iter_dic',Iter_dic,'Percent',Percent,'Iter_unused',Iter_unused);
Psi_Online = Online_DIC_MBPS09('trainblkMatrix64_400.mat','testblkMatrix_6k.mat',param);

%%
% design projection matrices
param_Robust = struct('M',M,'lambda',lambda,'D',Psi_Online);
Phi_MT = Robust_Project_Matrix(param_Robust);

%% test image
im = imread('Data\lena.png');
im = double(im);
[im,~,~] = our_im2col(im,blkSize);
im_mean = mean(im);
im_mean_0 = im - ones(size(im,1),1)*im_mean;
PSNR_MT = showImage(im_mean_0,Phi_MT,Psi_Online,K);
fprintf('The PSNR for MT matrix is: %d\n',PSNR_MT)
