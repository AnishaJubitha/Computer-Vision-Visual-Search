%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_computedescriptors.m
%% Skeleton code provided as part of the coursework assessment
%% This code will iterate through every image in the MSRCv2 dataset
%% and call a function 'extractRandom' to extract a descriptor from the
%% image.  Currently that function returns just a random vector so should
%% be changed as part of the coursework exercise.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'D:\OneDrive\Personal\Surrey\SurreyLearn\Sem2_CVPR\msrc_objcategimagedatabase_v2\MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = 'D:\OneDrive\Personal\Surrey\SurreyLearn\Sem2_CVPR\cwork_basecode_2012\descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
OUT_SUBFOLDER='globalRGBhisto';
Q = [4];
for i=Q
    allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
    for num=1:length(allfiles)
        fname=allfiles(num).name;
        fprintf('Processing file %d/%d - %s\n',num,length(allfiles),fname);
        tic;
        imgName=([DATASET_FOLDER,'/Images/',fname]);
        img=double(imread(imgName));
        fout=[OUT_FOLDER,'\',OUT_SUBFOLDER,'\',int2str(i),'\',fname(1:end-4),'.mat'];%replace .bmp with .mat
        %F=cvpr_RGBhistogram(img,i);
        F=cvpr_SpatialGridColorTexture(img, 4, 4, 7, 0.09);
        save(fout,'F');
        toc
    end
end
