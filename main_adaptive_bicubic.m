%% this is the main code for producing HR image 
img = imread("standard_test_images\standard_test_images\lena_gnd.bmp");
LR_img = imread("standard_test_images\standard_test_images\lena.png");
LR_img = double(LR_img);
[M,N,K]=size(img);
img=double(img);

factor=4;
HR_img_color = zeros (M,N,K);
tic 
for i = 1 : K 
    %LR_img = ABI (img(:,:,i),1/factor,0);
   
   
    HR_img = ABCI (LR_img(:,:,i),factor,0.06);


    HR_img_color(:,:,i) = HR_img;
end 
toc 
%LR_img = imresize(img,[M/factor, N/factor ],'bilinear');
tic 
img_BI=imresize(LR_img , [M N ],"bicubic");
toc 
MSE_ABI=sqrt(mean((uint8(HR_img_color)-uint8(img)).^2,"all"));
MSE_BI=sqrt(mean((uint8(img_BI)-uint8(img)).^2,"all"));

figure;
imshow(uint8(HR_img_color))

figure;
imshow(uint8(img_BI))
 
imwrite(uint8(HR_img_color),"Lenna_adaptive_interpolation_super_high_bicubic.png")


PSNR_ABI = psnr (uint8(HR_img_color),uint8(img));
PSNR_BI = psnr (uint8(img_BI),uint8(img));

SSIM_ABI = ssim (uint8(HR_img_color),uint8(img));
SSIM_BI = ssim (uint8(img_BI),uint8(img));

HR_img_R=HR_img_color(:,:,1);
HR_img_G=HR_img_color(:,:,2);
HR_img_B=HR_img_color(:,:,3);

HR_img_R_FT = 20*log10(abs(fftshift(fft2(HR_img_R))));
r_max=max(HR_img_R_FT,[],"all");
r_min=min(HR_img_R_FT,[],"all");
L=256;
a=(L-1)./(r_max-r_min);
b=-a.*r_min;
HR_img_R_FT=a.*HR_img_R_FT+b;

figure ; 
imshow(uint8(abs(HR_img_R_FT)))
title(" 2D FFT of HR Image using adaptive interpolation")

figure;

Bi_img_R_FT=20*log10(abs(fftshift(fft2(img_BI(:,:,1)))));
r_max=max(Bi_img_R_FT,[],"all");
r_min=min(Bi_img_R_FT,[],"all");
L=256;
a=(L-1)./(r_max-r_min);
b=-a.*r_min;
Bi_img_R_FT=a.*Bi_img_R_FT+b;

imshow(uint8(  abs(Bi_img_R_FT)   ))
title(" 2D FFT of HR Image using bicubic interpolation")



figure ; 
OR_img_R_FT = 20*log10(abs(fftshift(fft2(img(:,:,1)))));
r_max=max(OR_img_R_FT,[],"all");
r_min=min(OR_img_R_FT,[],"all");
L=256;
a=(L-1)./(r_max-r_min);
b=-a.*r_min;
OR_img_R_FT=a.*OR_img_R_FT+b;
imshow (uint8 (abs(OR_img_R_FT)))
title(" 2D FFT of original HR Image ")