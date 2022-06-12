% read ground truth image
im = imread('Data/Testing/Lena_gnd.bmp');
pics = {'Data/Testing/Lena128_res.png',...
    'Data/Testing/lena_bicubic.png',...
    'Data/Testing/Lena128_gauss_filt_025_res.png',...
    'Data/Testing/Lena128_gauss_filt_res.png',...
    'Data/Testing/Lena128_lambda_1_res.png',...
    'Data/Testing/Lena128_lambda_004_res.png',...
    'Data/Testing/Lena128_rand_dict_res.png',...
    'Data/Testing/Lena128_single_dict.png',...
    'Data/Testing/Lena128_sobel_res.png',...
    'Data/Testing/Lena128_unity_res.png',...
    'Data/Testing/Lenna_adaptive_interpolation_high.png',...
    'Data/Testing/Lenna_adaptive_interpolation_low.png',...
    'Data/Testing/Lena_high_adapt.png',...,
    'Data/Testing/Lena_coupled_10000.png',...
    'Data/Testing/Lena128_rand_dict_human_face.png'...
    };
im_test = zeros(512, 512, 3, length(pics));
% size(im_test)
for i=1:length(pics)
    im_test(:, :, :, i) = imread(char(pics(i)));
end

% imshow(uint8(im_test(:, :, :, 12)))
% figure
% imshow(uint8(im))

% compute PSNR for the illuminance channel
test_rmse = zeros(length(pics), 1);
test_psnr = zeros(length(pics), 1);
test_ssim = zeros(length(pics), 1);
for i=1:length(pics)
%     test_rmse(i) = compute_rmse(im, im_test(:, :, :, i));
    test_rmse(i) = sqrt(mean((uint8(im)-uint8(im_test(:, :, :, i))).^2,"all"));
    test_psnr(i) = psnr (uint8(im),uint8(im_test(:, :, :, i)));
    test_ssim(i) = ssim (uint8(im),uint8(im_test(:, :, :, i)));
end
test_rmse
test_psnr
test_ssim

HR_img_R = im_test(:, :, :, 13); % best

HR_img_R_FT = 20*log10(abs(fftshift(fft2(HR_img_R(:, :, 1)))));
r_max=max(HR_img_R_FT,[],"all");
r_min=min(HR_img_R_FT,[],"all");
L=256;
a=(L-1)./(r_max-r_min);
b=-a.*r_min;
HR_img_R_FT=a.*HR_img_R_FT+b;

figure ; 
imshow(uint8(abs(HR_img_R_FT)))
title(" 2D FFT of HR Image using adaptive + sparse coding")


% test_qssim = zeros(length(pics), 1);
% for i=1:length(pics)
%     [test_qssim(i), ~] = qssim(im, im_test(:, :, :, i));
% end
% test_qssim
% [qssim_sp,~] = qssim(im, im_h);
% [qssim_in,~] = qssim(im, im_b);

% im_gray = rgb2gray(im);
% im_h_gray = rgb2gray(im_h);
% im_b_gray = rgb2gray(im_b);
% [ssim_sp,~] = ssim_index(im_gray,im_h_gray);
% [ssim_in,~] = ssim_index(im_gray,im_b_gray);

% fn_full = fullfile('Data/Testing/House_Of_Cards_2013_S02E01_0135_wanted_res.png');
% fid = fopen(fn_full,'w+');
% fclose(fid);
% imwrite(im_h,fn_full);
% 
% bb_psnr = 20*log10(255/bb_rmse);
% sp_psnr = 20*log10(255/sp_rmse);
% 
% 
% fprintf('PSNR for Bicubic Interpolation: %f dB\n', bb_psnr);
% fprintf('PSNR for Sparse Representation Recovery: %f dB\n', sp_psnr);
% 
% disp([num2str(bb_psnr),num2str(ssim_in),num2str(qssim_in)]);
% 
% disp([num2str(sp_psnr),num2str(ssim_sp),num2str(qssim_sp)]);
% % show the images
% figure, imshow(im_h);
% title('Sparse Recovery');
% figure, imshow(im_b);
% title('Bicubic Interpolation');