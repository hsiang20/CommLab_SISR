function HR_image = ABI(LR_image,factor,alpha)
    f=LR_image;
    [M,N]=size(f);
    G=zeros(M*factor,N*factor);
    for i=1:factor*N
        for j=1:factor*M
            x=max((i-0.5)/factor-0.5,0);
            y=max((j-0.5)/factor-0.5,0);
            x1=floor(x);
            x2=min(ceil(x),N-1);
            y1=floor(y);
            y2=min(ceil(y),M-1);
            s=x-x1;
            t=y-y1;
            x0=max(0,x1-1);
            y0=max(0,y1-1);
            x3=min(M-1,x2+1);
            y3=min(M-1,y2+1);
            %% ==== computed mask value ===================================
            Hl=1/sqrt(1+alpha*( abs(f(y1+1,x1+1)-f(y1+1,x0+1)) + abs(f(y2+1,x1+1)-f(y2+1,x0+1)) ));
            Hr=1/sqrt(1+alpha*( abs(f(y1+1,x2+1)-f(y1+1,x3+1)) + abs(f(y2+1,x2+1)-f(y2+1,x3+1)) ));
            Vu=1/sqrt(1+alpha*( abs(f(y1+1,x1+1)-f(y0+1,x1+1)) + abs(f(y1+1,x2+1)-f(y0+1,x2+1)) ));
            Vl=1/sqrt(1+alpha*( abs(f(y2+1,x1+1)-f(y3+1,x0+1)) + abs(f(y2+1,x2+1)-f(y3+1,x2+1)) ));
            Dh=Hl*(1-s)+Hr*s;
            Dv=Vu*(1-t)+Vl*t;
            w0h=Hl*(1-s)/Dh;
            w1h=Hr*s/Dh;
            w0v=Vu*(1-t)/Dv;
            w1v=Vl*t/Dv;
            G(j,i)=w0v*(w0h*f(y1+1,x1+1)+w1h*f(y1+1,x2+1))+w1v*(w0h*f(y2+1,x1+1)+w1h*f(y2+1,x2+1));

        end 
    end 
    HR_image=G;
end 