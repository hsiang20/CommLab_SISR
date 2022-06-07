function HR_image = ABCI_color(LR_image,factor,alpha)
    LR_image=double(LR_image);
    
    [M,N,K]=size(LR_image);
    G=zeros(M*factor,N*factor,K);
    
    for k = 1 : K
        f=LR_image(:,:,k);
        
        f=wextend(2,'sp0',f,2);
        f=f(3:end,3:end);
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
                
                P_s = [ (-s^3+2*s^2-s)/2 (3*s^3-5*s^2+2)/2 (-3*s^3+4*s^2+s)/2  (s^3-s^2)/2   ];
                P_t = [ (-t^3+2*t^2-t)/2 (3*t^3-5*t^2+2)/2 (-3*t^3+4*t^2+t)/2  (t^3-t^2)/2   ];
                Dh=P_s(1)+Hl*P_s(2)+Hr*P_s(3)+P_s(4);
                Dv=P_t(1)+Vu*P_t(2)+Vl*P_t(3)+P_t(4);
                w0h= [P_s(1)/Dh Hl*P_s(2)/Dh Hr*P_s(3)/Dh P_s(4)/Dh ];
                w0v= [P_t(1)/Dv Vu*P_t(2)/Dv Vl*P_t(3)/Dv P_t(4)/Dv ];
        
                
                for m = -1:2 
                    for n = -1 : 2
                       G(j,i,k)=G(j,i,k)+f(max(y1+1+n,1),max(x1+1+m,1))*w0h(m+1+1)*w0v(n+1+1);
                    end 
                end 
            end 
        end 
    end 
    HR_image=uint8(G);

end 