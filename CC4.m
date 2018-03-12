clear;
clc;
A =[1,1,1,1,1,1,1,1,1,1;
    1,0,0,0,0,0,0,0,1,1;
    1,0,0,0,0,0,0,0,1,1;
    1,0,0,1,1,1,1,1,1,1;
    1,0,0,1,1,1,1,1,1,1;
    1,0,0,0,0,0,0,0,0,1;
    1,0,0,0,0,0,0,0,0,1;
    1,0,0,1,1,1,1,1,1,1;
    1,0,0,0,0,0,0,0,1,1;
    1,0,0,0,0,0,0,0,1,1];

A1 =[nan,1,nan,1,nan,nan,nan,1,nan,nan;
    nan,nan,nan,nan,nan,0,nan,0,1,nan;
    1,nan,0,nan,nan,0,nan,0,nan,1;
    1,0,nan,1,nan,nan,nan,1,nan,1;
    nan,0,nan,nan,1,nan,1,nan,nan,1;
    nan,nan,nan,0,nan,nan,nan,0,nan,1;
    1,nan,0,nan,0,nan,nan,0,nan,nan;
    nan,0,nan,1,nan,1,nan,nan,1,1;
    1,nan,0,nan,nan,nan,0,nan,1,nan;
    1,nan,0,nan,nan,nan,0,nan,nan,1]

figure(1),imshow(A);
a1=sum(A,2)

[sx,sy]=size(A);
M=[]
r=0;
h=1;
l=1;
for i=1:sx %extracting pixel coordinates of the training samples
    for j=1:sy
        if (A1(i,j)==0 || A1(i,j)==1)
            Y(h,1) = i;
            Y(h,2) = j;
            h=h+1
        end
    end
end

[x1,y1]=size(Y);

for i=1:x1 %converting the obtained pixel valus to unary coding and storing the corresponding hidden neuron 
    K{i,1}=concat(Y(i,1),Y(i,2)); %convert to unary code
    K{i,2}=A1(Y(i,1),Y(i,2)); %store the corresponding pixel input
    Val(i,1)=K{i,2}; 
end
t=1;
for i=1:sx %extract all the probe vectors pixel coordinates to be sent for testing
    for j=1:sy
        if (A(i,j)==0 || A(i,j)==1) 
            Mat(t,1) = i;
            Mat(t,2) = j;
            t=t+1;
        end
    end
end

[x2,y2]=size(Mat);

for i=1:x2 %convert all the extracted pixel coordinates to unary code
    Test{i,1}=concat(Mat(i,1),Mat(i,2));
end



for i=1:x1
    Ele=K{i,1};
    for h=1:numel(Ele)-1
                if Ele(1,h)==0
                      Ele(1,h)=-1;
                end
                s = sum(Ele(:) == 1);
                Ele(1,numel(Ele))=r-s+1;
    end
    K{i,3}=Ele;
end
a=size(Test,1);
b=size(K,1);
for i=1:a
    for j=1:b
        New(i,j)=Test{i,1}*K{j,3}';
        if New(i,j)>0
            New(i,j)=1;
        else
            New(i,j)=0;
        end
    end
end


NewVal=New*Val;
for i=1:size(NewVal,1)
    if NewVal(i,1)>0
        Mat(i,3)=1;
    else
        Mat(i,3)=0;
    end
end

for i=1:size(Mat,1)
    final(Mat(i,1),Mat(i,2))=Mat(i,3)
end
count=0;
for i=1:size(final,1)
    for j=1:size(final,2)
        if (final(i,j)~=A(i,j))
            count=count+1
        end
    end
end

figure(2),imshow(final);


% Neu=New';

% for i=1:size(Neu,2)
%     

% for i=1:sx
    

function ct=concat(a,b)
A =[1,1,1,1,1,1,1,1,1,1;
    1,0,0,0,0,0,0,0,1,1;
    1,0,0,0,0,0,0,0,1,1;
    1,0,0,1,1,1,1,1,1,1;
    1,0,0,1,1,1,1,1,1,1;
    1,0,0,0,0,0,0,0,0,1;
    1,0,0,0,0,0,0,0,0,1;
    1,0,0,1,1,1,1,1,1,1;
    1,0,0,0,0,0,0,0,1,1;
    1,0,0,0,0,0,0,0,1,1];

    [sx,sy]=size(A)
    u=ones(1,a)
    v= zeros(1,sx-numel(u));
    ct1 = cat(2,v,u)
    u1=ones(1,b)
    v1= zeros(1,sy-numel(u1));
    ct2 = cat(2,v1,u1)
    ct3 = cat(2,ct1,ct2)
    b=ones(1);
    ct= cat(2,ct3,b)
end

