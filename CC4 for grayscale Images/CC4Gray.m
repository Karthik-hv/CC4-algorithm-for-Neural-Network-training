clear;
clc;
tic
Image=imread('Lena120.jpg');

% IM2=im2double(Image);
% for i=1:size(Image,1)
%     for j=1:size(Image,2)
%         if IM2(i,j)>0 && IM2(i,j)<0.5
%             IMG(i,j)=1;
%         elseif IM2(i,j)>0 && IM2(i,j)>0.5
%             IMG(i,j)=2;
%         end
%     end
% end
% Red(:,:)=Image(:,:,1);
% Green(:,:)=Image(:,:,2);
% Blue(:,:)=Image(:,:,3);


New_training=zeros(120) %64);

num_samples=size(Image,1)*size(Image,2);
train=5760 %7200 %4320  %1638; %different percentage of samples
 [idx,idx]=sort(rand(1,num_samples));
 out=idx(1:train);
 x = sort(out);
count=0;
for i=1:size(x,2) %Extract the training image 
    New_training(x(i))=Image(x(i));

end

for i=1:size(Image,1) %Extract the training image 
    for j=1:size(Image,2)
        if New_training(i,j)>0
            count=count+1
        end
    end
end

% New_training = cat(1, zeros(size(Training,2),2)', Training);

Samples=(size(New_training,1)*size(New_training,2))-count;

[sx,sy]=size(Image);
M=[]
r=3; %radius of generalization
h=1;
l=1;
for i=1:sx %extracting pixel coordinates of the training samples
    for j=1:sy
        if (New_training(i,j)>0)
            Y(h,1) = i;
            Y(h,2) = j;
            h=h+1;
        end
    end
end

[x1,y1]=size(Y);

for i=1:x1 %converting the obtained pixel valus to unary coding and storing the corresponding hidden neuron 
    K{i,1}=concat(Y(i,1),Y(i,2)); %convert to unary code
    K{i,2}=New_training(Y(i,1),Y(i,2)); %store the corresponding pixel input
    Val(i,1)=K{i,2}; 
end
t=1;
for i=1:sx %extract all the probe vectors pixel coordinates to be sent for testing
    for j=1:sy
        if (Image(i,j)>=0) 
            Mat(t,1) = i;
            Mat(t,2) = j;
            t=t+1;
        end
    end
end

[x2,y2]=size(Mat);

for i=1:x2 
    NewMat{i,1}=concat(Mat(i,1),Mat(i,2));
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

a=size(NewMat,1);
b=size(K,1);

for i=1:a
    for j=1:b
        New(i,j)=NewMat{i,1}*K{j,3}';
            if New(i,j)>0
            New(i,j)=1;
        else
            New(i,j)=0;
        end
    end
end

for i=1:size(Val,1)
    for j=1:size(Val,2)
        temp=Val(i,j);
        Value(i,j)=temp;
    end
end

testmat=im2double(Value);

for i=1:size(Val,1)
    for j=1:size(Val,2)
        temp=Val(i,j);
        testmat(i,j)=temp;
    end
end


% Hidden_Neu=New';
NewVal=New*testmat;

for i=1:size(New,1)
    for j=1:size(New,2)
        temp=sum(New(i,:));
        Sum1(i,1)=temp;
    end
end

for i=1:size(NewVal,1)
    for j=1:size(NewVal,2)
        Valu=NewVal(i,j)/Sum1(i,j);
        Output1(i,j)=Valu;
    end
end

% out=sum(New,2);
        
% for i=1:size(NewVal,1)
%     for j=1:size(NewVal,2)
%         temp=mod(NewVal(i,j),255);
%         NewVal1(i,j)=temp;
%     end
% end
% 
% for i=1:size(Mat,1)
%     final(Mat(i,1),Mat(i,2))=NewVal1(i,1);
% end

for i=1:size(Mat,1)
    final1(Mat(i,1),Mat(i,2))=Output1(i,1);
end


figure(1),imshow(Image);
figure(2),imshow(uint8(final1));

toc   

% imshow(Blue);