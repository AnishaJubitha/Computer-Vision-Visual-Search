
close all;
clear all;

DATASET_FOLDER = 'D:\OneDrive\Personal\Surrey\SurreyLearn\Sem2_CVPR\msrc_objcategimagedatabase_v2\MSRC_ObjCategImageDatabase_v2';

DESCRIPTOR_FOLDER = 'D:\OneDrive\Personal\Surrey\SurreyLearn\Sem2_CVPR\cwork_basecode_2012\descriptors';

DESCRIPTOR_SUBFOLDER='globalRGBhisto';

Q = 4
ALLFEAT=[];
ALLCATs=[];
FILES=cell(1,0);
ctr=1;

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for num=1:length(allfiles)
    fname=allfiles(num).name;
    
    splitString = split(fname, '_');
    ALLCATs(num) = str2double(splitString(1));
    

    imgName=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgName));
    fout=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    F=cvpr_RGBhistogram(img, Q);
    F=cvpr_SpatialGridColorTexture(img, 4, 4, 7, 0.09);
    ALLFEAT = [ALLFEAT; F];

    FILES{ctr}=imgName;
    ctr=ctr+1; 
    save(fout,'F');
end

CAT_HIST = histogram(ALLCATs).Values;
CAT_TOTAL = length(CAT_HIST);

NIMG=size(ALLFEAT,1);           % number of images in collection
    

confusion_matrix = zeros(CAT_TOTAL);

all_precision = [];
all_recall = [];

AP_values = zeros([1, CAT_TOTAL]);

fAllfeat=ALLFEAT;
allfeatPCA=computePCA(fAllfeat); 

obs=fAllfeat-repmat(allfeatPCA.org,size(fAllfeat,1),1);
pobs=((allfeatPCA.vct')*(obs'))';

queryimg = 481;


dst=[];
for i=1:NIMG
    candidate=pobs(i,:);
    query=pobs(queryimg,:);

    category=ALLCATs(i);

        %% COMPARE FUNCTION
    thedst=cvpr_compareMahalanobis(allfeatPCA, query,candidate);
    dst=[dst ; [thedst i category]];
end
dst=sortrows(dst,1);  % sort the results

    %% 4) Calculate PR
precisionValues=zeros([1, NIMG]);
recallValues=zeros([1, NIMG]);

    %correct_at_n=zeros([1, NIMG]);

query_row = dst(1,:);
query_category = query_row(1,3);

for i=1:size(dst,1)

    rows = dst(1:i, :);

    correct_results = 0;
    incorrect_results = 0;

    if i >= 1    
        for n=1:i
            row = rows(n, :);
            category = row(3);

            if category == query_category
                correct_results = correct_results + 1;
            else
                incorrect_results = incorrect_results + 1;
            end

        end
    end
    precision = correct_results / i;
    recall = correct_results / CAT_HIST(1,query_category);

    precisionValues(i) = precision;
    recallValues(i) = recall;

end

average_precision = sum(precisionValues) / CAT_HIST(1,query_category);


 
all_precision = [all_precision ; precisionValues];
all_recall = [all_recall ; recallValues];

figure(1)
plot(recallValues(), precisionValues());
hold on;
title('PR Curve');
xlabel('Recall');
ylabel('Precision');
hold off;

SHOW=10; 
dst=dst(1:SHOW,:);
outdisplay=[];
for i=1:size(dst,1)
    img=imread(FILES{dst(i,2)});
    img=img(1:2:end,1:2:end,:); 
    img=img(1:81,:,:); 
    outdisplay=[outdisplay img];
end

figure(2)
imshow(outdisplay);


mean_precision = mean(all_precision);
mean_recall = mean(all_recall);
    
