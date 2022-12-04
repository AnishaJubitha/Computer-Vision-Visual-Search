%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m


close all;
clear all;


DATASET_FOLDER = 'D:\OneDrive\Personal\Surrey\SurreyLearn\Sem2_CVPR\msrc_objcategimagedatabase_v2\MSRC_ObjCategImageDatabase_v2';

DESCRIPTOR_FOLDER = 'D:\OneDrive\Personal\Surrey\SurreyLearn\Sem2_CVPR\cwork_basecode_2012\descriptors';

DESCRIPTOR_SUBFOLDER='globalRGBhisto';


Q = [4]
for quant = Q
    ALL=[];
    all_precision = [];
    all_recall = [];
    FILES=cell(1,0);
    ALLCATs=[];
    ctr=1;
    allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
    for num=1:length(allfiles)
        fname=allfiles(num).name; 
        splitString = split(fname, '_');
        ALLCATs(num) = str2double(splitString(1));
    
        imgName=([DATASET_FOLDER,'/Images/',fname]);
        img=double(imread(imgName))./255;
        thesefeat=[];
        ftfile=[DESCRIPTOR_FOLDER,'\',DESCRIPTOR_SUBFOLDER,'\',int2str(quant),'\',fname(1:end-4),'.mat'];%replace .bmp with .mat
        load(ftfile,'F');
        FILES{ctr}=imgName;
        ALL=[ALL ; F];
        ctr=ctr+1; 
    end

    % get counts for each category for PR calculation
    CAT_HIST = histogram(ALLCATs).Values;
    CAT_TOTAL = length(CAT_HIST);

    NIMG=size(ALL,1);           % number of images in collection
    queryimg=floor(rand()*NIMG);    % index of a random image

    queryimg = 481;
    if queryimg == 0
        queryimg = 1;
    end

    %% 3) Compute the distance of image to the query
    dst=[];
    for i=1:NIMG
        candidate=ALL(i,:);
        query=ALL(queryimg,:);

        category=ALLCATs(i);

        %% COMPARE FUNCTION
        dstfn=cvpr_L2norm(query,candidate);
        dst=[dst ; [dstfn i category]];
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

        correctRes = 0;
        incorrectRes = 0;

        if i >= 1    
            for n=1:i
                row = rows(n, :);
                category = row(3);

                if category == query_category
                    correctRes = correctRes + 1;
                else
                    incorrectRes = incorrectRes + 1;
                end

            end
        end
        precision = correctRes / i;
        recall = correctRes / CAT_HIST(1,query_category);

        precisionValues(i) = precision;
        recallValues(i) = recall;
        
        
    end

    
    avg_precision = sum(precisionValues) / CAT_HIST(1,query_category);

    figure(1);
    plot(recallValues(:), precisionValues(:), 'Marker', 'o');
    hold on;
    title('PR Curve');
    xlabel('Recall');
    ylabel('Precision');
    
    all_precision = [all_precision ; precisionValues];
    all_recall = [all_recall ; recallValues];

    

end

hold off;

 SHOW=10; % Show top 25 results
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