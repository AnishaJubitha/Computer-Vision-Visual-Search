function F=cvpr_SpatialGridColorTexture(img, grid_rows, grid_columns, bins, threshold)

img_size = size(img);
img_rows = img_size(1);
img_cols = img_size(2);

descriptor = [];

for i = 1:grid_rows
    for j = 1:grid_columns
        
        
        row_start = round( (i-1)*img_rows/grid_rows );
        if row_start == 0
            row_start = 1;
        end
        row_end = round( i*img_rows/grid_rows );
        
        col_start = round( (j-1)*img_cols/grid_columns );
        if col_start == 0
            col_start = 1;
        end
        col_end = round( j*img_cols/grid_columns );
        
        img_cell = img(row_start:row_end, col_start:col_end, :);
        grey_img_cell = img_cell(:,:,1) * 0.3 + img_cell(:,:,2) * 0.59 + img_cell(:,:,3) * 0.11;
        
       
        avg_vals = cvpr_extractRandom(img_cell);
        [mag_img, angle_img] = cvpr_getEdgeInfo(grey_img_cell);
        
        edge_hist = cvpr_getEdgeAngleHist(mag_img, angle_img, bins, threshold);
        
        %descriptor = [descriptor avg_vals(1) avg_vals(2) avg_vals(3)];
        %descriptor = [descriptor edge_hist];
        descriptor = [descriptor edge_hist avg_vals(1) avg_vals(2) avg_vals(3)];
        
    end
end

F=descriptor;
return;