%% this is the main code for producing HR image 
img = imread("standard_test_images\standard_test_images\lena_color_512.tif");

[M,N,K]=size(img);
img=double(img);
factor=4;
HR_img_color = zeros (M,N,K);
for i = 1 : K 

    LR_img = imresize(img(:,:,i),[M/factor, N/factor],'bilinear');
    
    HR_img = ABI (LR_img,4,1);
    
    
    
    
    HR_img_color(:,:,i) = HR_img;
end 

LR_img = imresize(img,[M/factor, N/factor ],'bilinear');
img_BI=imresize(LR_img , [M N ],"bilinear");

MSE_ABI=sqrt(mean((uint8(HR_img_color)-uint8(img)).^2,"all"));
MSE_BI=sqrt(mean((uint8(img_BI)-uint8(img)).^2,"all"));

figure;
imshow(uint8(HR_img_color))

figure;
imshow(uint8(img_BI))
 
imwrite(uint8(HR_img_color),"Lenna_adaptive_interpolation_high.png")


PSNR_ABI = psnr (uint8(HR_img_color),uint8(img));
PSNR_BI = psnr (uint8(img_BI),uint8(img));

SSIM_ABI = ssim (uint8(HR_img_color),uint8(img));
SSIM_BI = ssim (uint8(img_BI),uint8(img));

