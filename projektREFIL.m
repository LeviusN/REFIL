clear all, clc;

%% Zadane hodnoty
xi=[0,2.7,6.8,9,9.2,8.6,8,7.8,7.8,7.9,8];
xi=xi.*2.5;
n=3;
N=7;
iteracie=N-n;
%% Vypocet matice H a Y

% Matica H
H=zeros(N-n,n);
for i=1:n
    for j=1:N-n
        H(j,i)=xi(j+1+(i-1))-xi(j);
    end
end

% Vektor y
y=zeros(N-n,1);
for i=1:N-n
    y(i)=-(xi(i+1)-xi(i));
end


%% Program RMNS
format long
% Inicializacia
n=3;
G=10e10*eye(n);
ThetaG=(zeros(1,n))';

Z=[-14.16 1 -2.04; 
    -12.6 1 0; 
    -7.08 1 4.08; 
    -4.92 1 7.92];
ThetaM=zeros(iteracie, 2)
QM=zeros(iteracie,1)
GM=zeros(iteracie*n,n)
ss=0;
l=1;
g=zeros(n,n);
% Algoritmus
gama=G(n,n);
g=G(n,1:n-1);
Theta=-g/gama
Q=1/gama^2;
for k=1:iteracie 
    q=1;
    f=G*Z(k,:)';
    s(q)=1;
    s(q+1)=sqrt(s(q)^2+f(1)^2);
    s(q+2)=sqrt(s(q+1)^2+f(2)^2);
    s(q+3)=sqrt(s(q+2)^2+f(3)^2);
%s=[1 1.0291 1.6718 3.9994]
% Matica G pomocou jednotlivich g(ij)
    for i=1:3 % riadok
        for j=1:3 % stlpec
            if j>=i
                part=0; % nic sa neprida
            else
                part=0;
                for m=j:i-1
                    part=part+f(m)*G(m,j);        
                end
            end          
            g(i,j)=(s(i)/s(i+1))*(G(i,j)-f(i)/(s(i)^2)*part);
        end
    end
G=g
gama=G(n,n);
g=G(n,1:n-1);
Theta=-g/gama;
Q=1/gama^2;

ThetaM(k,:)=Theta;
QM(k)=Q;
l=l+3*ss;
u=k*3;
GM(l:u,:)=G;
ss=1;
end

figure(1);
col={'1','2','3','4'};
row={'Theta1','Theta2'};
dat={ThetaM(1,1),ThetaM(2,1),ThetaM(3,1),ThetaM(4,1);
    ThetaM(1,2),ThetaM(2,2),ThetaM(3,2),ThetaM(4,2)};
uitable('columnname',col,'rowname',row,'data',dat,'columnwidth',{80});

