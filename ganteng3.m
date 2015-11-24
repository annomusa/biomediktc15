% Color-Based Segmentation Using K-Means Clustering

clear all; close all


a = zeros(3,5);
srcFiles = dir('.\smear dataset\carcinoma\*.BMP');
for i = 1 : length(srcFiles)
    filename = strcat('.\smear dataset\carcinoma\',srcFiles(i).name);
    I = imread(filename);
    % figure imshow(I);
    % disp(filename);
    % level 1 begin 
    he = imread(filename);

    % segmentasi color based start
    imshow(he), title('H&E image');
    text(size(he,2),size(he,1)+15,...
         'Image courtesy of Alan Partin, Johns Hopkins University', ...
         'FontSize',7,'HorizontalAlignment','right');

    cform = makecform('srgb2lab');
    lab_he = applycform(he,cform);

    ab = double(lab_he(:,:,2:3));
    nrows = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);

    nColors = 2;
    % repeat the clustering 3 times to avoid local minima
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                          'Replicates',20);

    pixel_labels = reshape(cluster_idx,nrows,ncols);
    imshow(pixel_labels,[]), title('image labeled by cluster index');

    segmented_images = cell(1,3);
    rgb_label = repmat(pixel_labels,[1 1 3]);

    for k = 1:nColors
        color = he;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;
    end

    imshow(segmented_images{1}), title('objects in cluster 1');

    imshow(segmented_images{2}), title('objects in cluster 2');

    imshow(segmented_images{3}), title('objects in cluster 3');

    mean_cluster_value = mean(cluster_center,2);
    [tmp, idx] = sort(mean_cluster_value);
    blue_cluster_num = idx(1);

    L = lab_he(:,:,1);
    blue_idx = find(pixel_labels == blue_cluster_num);
    L_blue = L(blue_idx);
    is_light_blue = im2bw(L_blue,graythresh(L_blue));

    nuclei_labels = repmat(uint8(0),[nrows ncols]);
    nuclei_labels(blue_idx(is_light_blue==false)) = 1;
    nuclei_labels = repmat(nuclei_labels,[1 1 3]);
    blue_nuclei = he;
    blue_nuclei(nuclei_labels ~= 1) = 0;
    imshow(blue_nuclei), title('blue nuclei');

    % segmentasi color based kelar

    g = rgb2gray(blue_nuclei);
    imt = im2bw(g, graythresh(g));
    figure; imshow (imt);

    % opening ukuran 50
    baru = bwareaopen(imt,50);
    baru = imopen(baru,strel('disk',1));
    figure; imshow (baru)

    % closing ukuran 50
    baru = bwareaopen(imt,50);
    baru = imclose(baru,strel('disk',1));
    figure; imshow (baru)

    [imlabel, objnum] = bwlabel(baru);

    stats = regionprops(imlabel,'all');
    % print stats(1);
    % index = stats(1);
    a(i,1) = [stats.Area];
    a(i,2) = [stats.MajorAxisLength];
    a(i,3) = [stats.MinorAxisLength];
%    a(i,4) = [srcFiles(i).name];
end



%x = imread(uigetfile ({'*.jpg;*.jpeg;*.tif;*.ppm;*.bmp'})); 
filename = ('.\smear dataset\carcinoma\149143370-149143378-003.BMP');
he = imread(filename);

% segmentasi color based start
imshow(he), title('H&E image');
text(size(he,2),size(he,1)+15,...
     'Image courtesy of Alan Partin, Johns Hopkins University', ...
     'FontSize',7,'HorizontalAlignment','right');

cform = makecform('srgb2lab');
lab_he = applycform(he,cform);

ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 2;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',20);

pixel_labels = reshape(cluster_idx,nrows,ncols);
imshow(pixel_labels,[]), title('image labeled by cluster index');

segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = he;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

imshow(segmented_images{1}), title('objects in cluster 1');

imshow(segmented_images{2}), title('objects in cluster 2');

imshow(segmented_images{3}), title('objects in cluster 3');

mean_cluster_value = mean(cluster_center,2);
[tmp, idx] = sort(mean_cluster_value);
blue_cluster_num = idx(1);

L = lab_he(:,:,1);
blue_idx = find(pixel_labels == blue_cluster_num);
L_blue = L(blue_idx);
is_light_blue = im2bw(L_blue,graythresh(L_blue));

nuclei_labels = repmat(uint8(0),[nrows ncols]);
nuclei_labels(blue_idx(is_light_blue==false)) = 1;
nuclei_labels = repmat(nuclei_labels,[1 1 3]);
blue_nuclei = he;
blue_nuclei(nuclei_labels ~= 1) = 0;
imshow(blue_nuclei), title('blue nuclei');

% segmentasi color based kelar

g = rgb2gray(blue_nuclei);
imt = im2bw(g, graythresh(g));
figure; imshow (imt);

% opening ukuran 50
baru = bwareaopen(imt,50);
baru = imopen(baru,strel('disk',1));
figure; imshow (baru)

% closing ukuran 50
baru = bwareaopen(imt,50);
baru = imclose(baru,strel('disk',1));
figure; imshow (baru)

[imlabel, objnum] = bwlabel(baru);

stats = regionprops(imlabel,'all');
% print stats(1);
% index = stats(1);
a(4,1) = [stats.Area];
a(4,2) = [stats.MajorAxisLength];
a(4,3) = [stats.MinorAxisLength];
%a(i,4) = [srcFiles(i).name];

