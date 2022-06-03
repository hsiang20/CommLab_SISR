% this code is the implementation of NNABI_1
%% ==== initialization ====================================================
clear;
img=imread("standard_test_images\standard_test_images\lena_gray_256.tif");
img_low=double(img);
%% ==== down sampling =====================================================
% first down sampling with NNABI method 
factor=1/2;
[M,N]=size(img_low);
Res1=zeros(N*factor,M*factor);
Res2=zeros(N*factor,M*factor);
% padding to avoid index error 
img_low=wextend(2,'sp0',img_low,1);
img_low=img_low(2:end,2:end,:);
%% ==== main loop =========================================================
for i = 1:N*factor
    for j = 1:M*factor
        f=img_low;
        x=i/factor;
        y=j/factor;
        x1=max(floor(x),1);
        x2=ceil(x);
        y1=max(floor(y),1);
        y2=ceil(y);
        %% ==== bilinear interpolation ====================================
        if  (y2-y1)==0
            r1=img_low(y1,x1);
            r2=img_low(y1,x2);
        else 
            r1=img_low(y1,x1)+ (y-y1)/(y2-y1)*(img_low(y2,x1)-img_low(y1,x1));
            r2=img_low(y1,x2)+ (y-y1)/(y2-y1)*(img_low(y2,x2)-img_low(y1,x2));
        end 
        if (x2-x1)==0
            Res1(j,i)=r1;
        else
            Res1(j,i)=r1+(x-x1)/(x2-x1)*(r2-r1);
        end 
        %% ==== adaptive process ==========================================
        dx=x-x1;
        dy=y-y1;
        x0=max(1,x1-1);
        y0=max(1,y1-1);
        x3=min(M,x2+1);
        y3=min(M,y2+1);
        
        if dx<0.5 && dy<0.5
            f(x1,y1)=(img_low(x0,y0)+img_low(x0,y1)+img_low(x1,y0)+img_low(x1,y1))/4;
        elseif dx<0.5 && dy>0.5
            f(x1,y2)=(img_low(x0,y2)+img_low(x0,y3)+img_low(x1,y2)+img_low(x1,y3))/4;
        elseif dx>0.5 && dy<0.5
            f(x2,y1)=(img_low(x2,y0)+img_low(x2,y1)+img_low(x3,y0)+img_low(x3,y1))/4;
        elseif dx>0.5 && dy>0.5
            f(x2,y2)=(img_low(x2,y2)+img_low(x2,y3)+img_low(x3,y2)+img_low(x3,y3))/4;
        elseif dx==0.5 && dy<0.5
            f(x1,y1)=(img_low(x0,y0)+img_low(x0,y1)+img_low(x1,y0)+img_low(x1,y1))/4;
            f(x2,y1)=(img_low(x2,y0)+img_low(x2,y1)+img_low(x3,y0)+img_low(x3,y1))/4;
        elseif dx==0.5 && dy>0.5
            f(x1,y2)=(img_low(x0,y2)+img_low(x0,y3)+img_low(x1,y2)+img_low(x1,y3))/4;
            f(x2,y2)=(img_low(x2,y2)+img_low(x2,y3)+img_low(x3,y2)+img_low(x3,y3))/4;
        elseif dx<0.5 && dy==0.5
            f(x1,y1)=(img_low(x0,y0)+img_low(x0,y1)+img_low(x1,y0)+img_low(x1,y1))/4;
            f(x1,y2)=(img_low(x0,y2)+img_low(x0,y3)+img_low(x1,y2)+img_low(x1,y3))/4;
        elseif dx>0.5 && dy==0.5
            f(x2,y1)=(img_low(x2,y0)+img_low(x2,y1)+img_low(x3,y0)+img_low(x3,y1))/4;
            f(x2,y2)=(img_low(x2,y2)+img_low(x2,y3)+img_low(x3,y2)+img_low(x3,y3))/4;
        elseif dx==0.5 && dy==0.5
            f(x1,y1)=(img_low(x0,y0)+img_low(x0,y1)+img_low(x1,y0)+img_low(x1,y1))/4;
            f(x1,y2)=(img_low(x0,y2)+img_low(x0,y3)+img_low(x1,y2)+img_low(x1,y3))/4;
            f(x2,y1)=(img_low(x2,y0)+img_low(x2,y1)+img_low(x3,y0)+img_low(x3,y1))/4;
            f(x2,y2)=(img_low(x2,y2)+img_low(x2,y3)+img_low(x3,y2)+img_low(x3,y3))/4;
        end 
        %% ==== bilinear interpolation ====================================
        if  (y2-y1)==0
            r1=f(y1,x1);
            r2=f(y1,x2);
        else 
            r1=f(y1,x1)+ (y-y1)/(y2-y1)*(f(y2,x1)-f(y1,x1));
            r2=f(y1,x2)+ (y-y1)/(y2-y1)*(f(y2,x2)-f(y1,x2));
        end 
        if (x2-x1)==0
            Res2(j,i)=r1;
        else
            Res2(j,i)=r1+(x-x1)/(x2-x1)*(r2-r1);
        end
    end 
end 
Res=max(Res1,Res2);
%% ==== upsampling ========================================================
img_low=Res;
factor=2;
[M,N]=size(img_low);
Res1=zeros(N*factor,M*factor);
Res2=zeros(N*factor,M*factor);
img_low=wextend(2,'sp0',img_low,1);
img_low=img_low(2:end,2:end,:);
%% ==== main loop =========================================================
for i = 1:N*factor
    for j = 1:M*factor
        f=img_low;
        x=i/factor;
        y=j/factor;
        x1=max(floor(x),1);
        x2=ceil(x);
        y1=max(floor(y),1);
        y2=ceil(y);
        %% ==== bilinear interpolation ====================================
        if  (y2-y1)==0
            r1=img_low(y1,x1);
            r2=img_low(y1,x2);
        else 
            r1=img_low(y1,x1)+ (y-y1)/(y2-y1)*(img_low(y2,x1)-img_low(y1,x1));
            r2=img_low(y1,x2)+ (y-y1)/(y2-y1)*(img_low(y2,x2)-img_low(y1,x2));
        end 
        if (x2-x1)==0
            Res1(j,i)=r1;
        else
            Res1(j,i)=r1+(x-x1)/(x2-x1)*(r2-r1);
        end 
        %% ==== adaptive process ==========================================
        dx=x-x1;
        dy=y-y1;
        x0=max(1,x1-1);
        y0=max(1,y1-1);
        x3=min(M,x2+1);
        y3=min(M,y2+1);
        if dx<0.5 && dy<0.5
            f(x1,y1)=(img_low(x0,y0)+img_low(x0,y1)+img_low(x1,y0)+img_low(x1,y1))/4;
        elseif dx<0.5 && dy>0.5
            f(x1,y2)=(img_low(x0,y2)+img_low(x0,y3)+img_low(x1,y2)+img_low(x1,y3))/4;
        elseif dx>0.5 && dy<0.5
            f(x2,y1)=(img_low(x2,y0)+img_low(x2,y1)+img_low(x3,y0)+img_low(x3,y1))/4;
        elseif dx>0.5 && dy>0.5
            f(x2,y2)=(img_low(x2,y2)+img_low(x2,y3)+img_low(x3,y2)+img_low(x3,y3))/4;
        elseif dx==0.5 && dy<0.5
            f(x1,y1)=(img_low(x0,y0)+img_low(x0,y1)+img_low(x1,y0)+img_low(x1,y1))/4;
            f(x2,y1)=(img_low(x2,y0)+img_low(x2,y1)+img_low(x3,y0)+img_low(x3,y1))/4;
        elseif dx==0.5 && dy>0.5
            f(x1,y2)=(img_low(x0,y2)+img_low(x0,y3)+img_low(x1,y2)+img_low(x1,y3))/4;
            f(x2,y2)=(img_low(x2,y2)+img_low(x2,y3)+img_low(x3,y2)+img_low(x3,y3))/4;
        elseif dx<0.5 && dy==0.5
            f(x1,y1)=(img_low(x0,y0)+img_low(x0,y1)+img_low(x1,y0)+img_low(x1,y1))/4;
            f(x1,y2)=(img_low(x0,y2)+img_low(x0,y3)+img_low(x1,y2)+img_low(x1,y3))/4;
        elseif dx>0.5 && dy==0.5
            f(x2,y1)=(img_low(x2,y0)+img_low(x2,y1)+img_low(x3,y0)+img_low(x3,y1))/4;
            f(x2,y2)=(img_low(x2,y2)+img_low(x2,y3)+img_low(x3,y2)+img_low(x3,y3))/4;
        elseif dx==0.5 && dy==0.5
            f(x1,y1)=(img_low(x0,y0)+img_low(x0,y1)+img_low(x1,y0)+img_low(x1,y1))/4;
            f(x1,y2)=(img_low(x0,y2)+img_low(x0,y3)+img_low(x1,y2)+img_low(x1,y3))/4;
            f(x2,y1)=(img_low(x2,y0)+img_low(x2,y1)+img_low(x3,y0)+img_low(x3,y1))/4;
            f(x2,y2)=(img_low(x2,y2)+img_low(x2,y3)+img_low(x3,y2)+img_low(x3,y3))/4;
        end 
        %% ==== bilinear interpolation ====================================
        if  (y2-y1)==0
            r1=f(y1,x1);
            r2=f(y1,x2);
        else 
            r1=f(y1,x1)+ (y-y1)/(y2-y1)*(f(y2,x1)-f(y1,x1));
            r2=f(y1,x2)+ (y-y1)/(y2-y1)*(f(y2,x2)-f(y1,x2));
        end 
        if (x2-x1)==0
            Res2(j,i)=r1;
        else
            Res2(j,i)=r1+(x-x1)/(x2-x1)*(r2-r1);
        end
    end 
end 
Res=max(Res1,Res2);
%% ==== MSE calculation ===================================================

MSE_NNAMI=sqrt(mean((uint8(Res)-uint8(img)).^2,'all'));

img_bi=imresize(img,[128 128],'bilinear');
img_bi=imresize(img_bi,[256 256],'bilinear');

MSE_bilinear=sqrt(mean((uint8(img_bi)-uint8(img)).^2,'all'));
figure;
imshow(uint8(Res))
figure;
imshow(uint8(img_bi))