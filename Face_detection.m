clc
clear 
close all

tic

How_many_faces_exists_in_Image = 10;

%% Step-1  Input Image from User
figure(1)
% [Name,Path] = uigetfile('*.jpg','Select Image to Input');
% concatinate_both  = strcat(Path,Name);
% Input_read =  imread(concatinate_both);
Input_read =  imread('Image.jpg');
subplot(2,2,1) , imshow(Input_read)
title('Input Image')

%% Step-2 check whether Image is RGb or Not  ?

[Row,Col,Frames] =  size(Input_read);

if(Frames==3) 
    msgbox('IMAGE TYPE IS RGB')
else 
    msgbox('IMAGE TYPE IS GRAYSCALE')
%     break
end

%% Step-3 show RGB Frames

red_frame =  Input_read(:,:,1);
green_frame = Input_read(:,:,2); 
blue_frame  = Input_read(:,:,3);

subplot(2,2,2), imshow(red_frame),title('Red Frame')
subplot(2,2,3) , imshow(green_frame) , title('Green Frame')
subplot(2,2,4), imshow(blue_frame), title('Blue Frame')

%% Step-4 Convert Image from RGB to Ycbcr
% B = rgb2hsv(A);
figure(2)
Image_ycbcr = rgb2ycbcr(Input_read);
subplot(2,2,1) , imshow(Image_ycbcr), title('RGB to Y_Cb_Cr')

%% Step -5 Seprate Y, Cb and Cr Frame

Image_ycbcr1 = Image_ycbcr(:,:,1) ; 
Image_ycbcr2 = Image_ycbcr(:,:,2) ; 
Image_ycbcr3 = Image_ycbcr(:,:,3) ; 

subplot(2,2,2), imshow(Image_ycbcr1),title('Y Frame')
subplot(2,2,3) , imshow(Image_ycbcr2) , title('Cb Frame')
subplot(2,2,4), imshow(Image_ycbcr3), title('Cr Frame')

%% Step-6 Convert Image from RGB to HSV

figure(3)
Image_hsv = rgb2hsv(Input_read);
subplot(2,2,1) , imshow(Image_hsv), title('RGB to HSV')

%% Step-7 Seprate H, S and V Frame

Image_hsv1 = Image_hsv(:,:,1) ; 
Image_hsv2 = Image_hsv(:,:,2) ; 
Image_hsv3 = Image_hsv(:,:,3) ; 

subplot(2,2,2), imshow(Image_hsv1), title('H frame')
subplot(2,2,3) , imshow(Image_hsv2),title('S frame')
subplot(2,2,4), imshow(Image_hsv3), title('V frame')

%% Step-8 Convert Input Image to GrayScale Image
figure(4)
gray_Image = rgb2gray(Input_read);
subplot(2,2,1), imshow(gray_Image ),title('RGB to Gray Conversion')

%% Step-9 Edge Detection of Input Image 

edge1 =  edge(gray_Image,'canny');
edge2 =  edge(gray_Image,'sobel');
edge3 =  edge(gray_Image,'prewitt');
subplot(2,2,2), imshow(~edge1), title('Canny Edge Detection')
subplot(2,2,3) , imshow(~edge2), title('Sobel Edge Detection') 
subplot(2,2,4), imshow(~edge3), title('Prewitt Edge Detection')

%% Step-10 Convert YcbCr Image to GrayScale Image
figure(5)
gray_Image1 = Image_ycbcr2;
subplot(2,2,1), imshow(gray_Image1), title('YCbCr to Grayscale')

%% Step-11 Edge Detection of Input Image 

edge11 =  edge(gray_Image1,'canny');
edge21 =  edge(gray_Image1,'sobel');
edge31 =  edge(gray_Image1,'prewitt');
subplot(2,2,2), imshow(~edge11), title('Canny-Invert Edges Pixel')
subplot(2,2,3) , imshow(~edge21), title('Sobel-Invert Edges Pixel') 
subplot(2,2,4), imshow(~edge31),title('Prewitt-Invert Edges Pixel')

%% Step-12 Conver Ycbcr Frame to Bw

thresh_val = graythresh(Image_ycbcr2); 
image_bw = im2bw(Image_ycbcr2);
figure,imshow(~image_bw), title('YCbCr to BW Conversion')

%% Step-13 Image LAbelling

[lableed_Image, Numbers] = bwlabel(~image_bw);
Labelled_Regions = Numbers
figure,imshow(lableed_Image), title('Labelled Image')
title(['Labelled Regions = ', num2str(Numbers)])

%% Step-14 Morphological Operations
erode_Image  =  bwmorph(image_bw,'erode');
dilate_Image  = bwmorph(image_bw,'dilate',3);

figure,imshow(erode_Image),title('Morphological- Erode Image')
figure,imshow(dilate_Image),title('Morphological- Dilate Image')

%% Step-15 Filter Image Labelling

[lableed_Image11, Numbers11] = bwlabel(~dilate_Image);
Morphological_Labelled_Regions = Numbers11
figure,imshow(lableed_Image11), title('Filtered Image')
title(['Labelled Regions = ', num2str(Numbers11)])

%% Step-16 After Euler Test

filter_Image = imfill(~dilate_Image,'holes');
figure,imshow(filter_Image), title('Fill Holes')

% Remove Unwanted Noise
filter_Image2 = bwareaopen(filter_Image,62);
figure,imshow(filter_Image2), title('Remove Unwanted Noise')

%% Step-17 Filter Image Labelling

[lableed_Image1, Numbers1] = bwlabel(filter_Image2);
Final_Labelled_Regions = Numbers1
figure,imshow(lableed_Image1), title('Label filtered Image')
title(['Labelled Regions = ', num2str(Numbers1)])

%% Step-18 Final Face Detection

figure,imshow(Input_read)
title(['Total Face Detected = ', num2str(Numbers1)])

%% Part-19 Plot Rectagle around Image

Iprops = regionprops(lableed_Image1);
Ibox = [Iprops.BoundingBox];
Ibox = reshape(Ibox,[4 Numbers1]);
figure,imshow(Input_read)
% Plot the Object Location
hold on;
for cnt = 1:Numbers1
    rectangle('position',Ibox(:,cnt),'edgecolor','r');
     pause(1)
end
title(['Total Face Detected = ', num2str(Numbers1)])


Accuracy = (How_many_faces_exists_in_Image/Numbers1)*100
Computation_Time = toc