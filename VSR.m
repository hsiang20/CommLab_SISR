%% ==== Read video ================================================
clear;
Vid = VideoReader('ForBiggerJoyrides.mp4');

%% ==== Write grayscale video =========================================
WriteVid = VideoWriter('GrayGoogle.avi', 'Grayscale AVI');
WriteVid.FrameRate = Vid.FrameRate;
open(WriteVid);
while hasFrame(Vid)
    frame = readFrame(Vid);
    frame = rgb2gray(frame);
    writeVideo(WriteVid, frame);
%     imshow(frame)
%     pause(1/Vid.FrameRate);
end
close(Write_Vid);
%% ==== Write downsampled video and SR video -- Bilinear====================
Vid = VideoReader('GrayGoogle.avi');
WriteVid_down = VideoWriter('GrayGoogle_bi_down.avi', 'Grayscale AVI');
WriteVid_bi = VideoWriter('GrayGoogle_bi.avi', 'Grayscale AVI');
WriteVid_down.FrameRate = Vid.FrameRate;
WriteVid_bi.FrameRate = Vid.FrameRate;
open(WriteVid_down);
open(WriteVid_bi);
factor = 1/4;
height = Vid.Height;
width = Vid.Width;
height_low = height * factor;
width_low = width * factor;
while hasFrame(Vid)
    frame = readFrame(Vid);
    img_bi = imresize(frame, [height_low width_low], 'bilinear');
    writeVideo(WriteVid_down, img_bi);
    img_bi = imresize(img_bi, [height width], 'bilinear');
    writeVideo(WriteVid_bi, img_bi);
end
close(WriteVid_down);
close(WriteVid_bi);

%% ==== Write downsampled video and SR video -- MNABI====================
Vid = VideoReader('GrayGoogle.avi');
WriteVid_down = VideoWriter('GrayGoogle_MNABI_down.avi', 'Grayscale AVI');
WriteVid_bi = VideoWriter('GrayGoogle_MNABI.avi', 'Grayscale AVI');
WriteVid_down.FrameRate = Vid.FrameRate;
WriteVid_bi.FrameRate = Vid.FrameRate;
open(WriteVid_down);
open(WriteVid_bi);
factor = 1/8;
M = Vid.Height;
N = Vid.Width;
height_low = M * factor;
width_low = N * factor;
while hasFrame(Vid)
    img = readFrame(Vid);
    % Downsampling
    img_low = double(img);
    Res1=zeros(height_low, width_low);
    Res2=zeros(height_low, width_low);
    % padding to avoid index error 
    img_low=wextend(2,'sp0',img_low,1);
    img_low=img_low(2:end,2:end,:);
    for i = 1:N*factor
        for j = 1:M*factor
            i = i
            j = j
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
            %% ==== adaptive process =======================================
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
    
    writeVideo(WriteVid_down, uint8(Res));
    
    % upsampling
    img_low=Res;
    factor = 1 / factor;
    [M,N]=size(img_low);
    Res1=zeros(N*factor,M*factor);
    Res2=zeros(N*factor,M*factor);
    img_low=wextend(2,'sp0',img_low,1);
    img_low=img_low(2:end,2:end,:);
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
    
    writeVideo(WriteVid_bi, uint8(Res));
end
close(WriteVid_down);
close(WriteVid_bi);