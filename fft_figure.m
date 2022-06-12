function fft_image=fft_figure(img)
    
    R = 20*log10(abs(fftshift(fft2(img(:,:,1)))));
    r_max=max(R,[],"all");
    r_min=min(R,[],"all");
    L=256;
    a=(L-1)./(r_max-r_min);
    b=-a.*r_min;
    R=a.*R+b;
    G = 20*log10(abs(fftshift(fft2(img(:,:,2)))));
    r_max=max(G,[],"all");
    r_min=min(G,[],"all");
    L=256;
    a=(L-1)./(r_max-r_min);
    b=-a.*r_min;
    G=a.*G+b;
    B = 20*log10(abs(fftshift(fft2(img(:,:,3)))));
    r_max=max(B,[],"all");
    r_min=min(B,[],"all");
    L=256;
    a=(L-1)./(r_max-r_min);
    b=-a.*r_min;
    B=a.*B+b;
    fft_image=cat(3,R,G,B);

end 