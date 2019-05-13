%%Set CD as pdata folder

%%#Given a tiff stack, destacks into image matricies
% @tiffFile: file name of tiff stack
tiffFile = '2dseq_256_256.tif'; %initialization
%%
fileInfo = imfinfo(tiffFile);
num_images = numel(fileInfo);
imageStack(:,:,1) = imread(tiffFile, 1, 'Info', fileInfo);
for i = 2 : num_images
    slice = imread(tiffFile, i, 'Info', fileInfo);
    imageStack(:,:,i) = slice;
end

%%#Splits image matrix into every 5th image starting with the 3rd image.
imageI = imageStack(:,:, 3:5:end);

%%#Loads visu_pars into matlab with correct delimiting
cd 2;
visu_pars_matrix = importdata('visu_pars', ' ', 100);
visu_pars_location = [63:81] %initialize slope location in data file
slopes = {};
        %%slopes = strsplit(char(visu_pars_matrix(visu_pars_location(1)))); %initialize slopes cell with first values from imported cell as a char array

for i = visu_pars_location(1:end)
    splitDelim = strsplit(char(visu_pars_matrix(i)));
    for j = 1:size(splitDelim, 2)
        slopes{end + j} = splitDelim{j};
    end
    
end
slopes = slopes(~cellfun(@isempty, slopes)); %%delmiting fix to load correct slope values
slopes = str2double(slopes);
cd ..;

%%#multiplies each image by slope value
for i = size(imageI, 3)
    imageI(:,:,i) = immultiply(imageI(:,:,i), slopes(3 + ((i - 1) * 5)));
end





%%#writes image stack to output tiff
outputTiff = 'processed_map.tif';
t = Tiff(outputTiff, 'w');
tagstruct.ImageLength = 256;
tagstruct.ImageWidth = 256;
tagstruct.Photometric = Tiff.Photometric.RGB;
tagstruct.BitsPerSample = 8; %8
tagstruct.SamplesPerPixel = 3;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software = 'MATLAB'
setTag(t,tagstruct);

write(t, imageI(:,:,1));

for i = 1 : length(imageI(1,1,:))
    imwrite(imageI(:,:,i), outputTiff, 'WriteMode', 'append');
end



imwrite(imageI, outputTiff);
for i = 2 : length(imageI(1,1,:))
    imwrite(imageI(:,:,i), outputTiff, 'WriteMode', 'append', 'Compression', 'none');
end



    
    

