clc;
clear all;
close all
warning off;
load train_test_labels
%
pdir='Train'; % 'Folder name'
   Orgf=dir([pdir '/*.jpg']); 
   for k=1:length(Orgf)
      CurrImg= Orgf(k).name;
      filn=[pdir '/' Orgf(k).name];
      Img=imread(filn);    
      Md=medfilt2(Img(:,:,1));
%       label = train_labels(17,:);
      train_x(:,:,k)=imresize(double(Md(:,:,1)),[28 28]);
      figure(1); subplot 121,imshow(Img);title('Original Image')        
       subplot 122,imshow(Md);title('Median Filter Image')  
   end

     
%%%%%%%%%%%%%%%%%%%%%  Test
pdir='Test'; % 'Folder name'
   Orgf=dir([pdir '/*.jpg']);    for k=1:length(Orgf)

      CurrImg= Orgf(k).name;
      filn=[pdir '/' Orgf(k).name];
      Img=imread(filn);   
      Md=medfilt2(Img(:,:,1));
      test_x(:,:,k)=imresize(double(Md(:,:,1)),[28 28]);

   end

h=28;
w=28;

cnn.n=1; 

cnn=It_cnn(cnn,[h w]);

 cnn=cnnACL(cnn, 40, [5 5], 'sigm');
 cnn=cnnAPL(cnn, 3, 'mean');
 cnn=cnnACL(cnn, 50, [3 3], 'sigm');
 cnn=cnnAPL(cnn, 2, 'mean');
cnn=cnnAFL(cnn,90, 'sigm' ); 
cnn=cnnAFL(cnn,10, 'sigm' ); 


epochs = 1;
bsi=14;
display 'training started...'
cnn=tr_cnn(cnn,train_x(:,:,1:14),train_y(:,1:14), epochs,bsi);
display '...training finished.'
display 'testing started....'
[err,acc]=te_cnn(cnn, test_x(:,:,1:6), test_y(:,1:6));

%%%%%%%%%%%%%%% Testing of Images
fprintf('------------------------------------------------------------------\n');
fprintf(' Lung Image   Accuracy Sensitivity Fmeasure Precision Specitivity\n');
pdir='Test'; % 'Folder name'
   Orgf=dir([pdir '/*.jpg']); 
   for k=1:length(Orgf)
      CurrImg= Orgf(k).name;
      filn=[pdir '/' Orgf(k).name];
      Img=imread(filn);   
      Md=medfilt2(Img(:,:,1));
      test_x(:,:,k)=imresize(double(Md(:,:,1)),[28 28]);
      Ind=imread('Normal1.jpg');
      Icmp=medfilt2(Ind(:,:,1));
      Icmp=imresize(double(Icmp),[28 28]);
      Cmp=sum(sum(test_x(:,:,k))) - sum(sum(Icmp));
      [Accuracy, Sensitivity, Fmeasure, Precision, Specitivity] = QualityMetrics(im2bw(Icmp), im2bw(test_x(:,:,k)));      
      fprintf('     %d         %.2f      %.2f        %.2f    %.2f       %.2f\n',k,Accuracy,Sensitivity,Fmeasure,Precision,Specitivity);
      if Cmp==0
          figure;
          imshow(Md),title('Input Image Cancer is not present'),helpdlg('Cancer is not present')
      else
          figure;
          imshow(Md),title('Input Image Cancer is present'),helpdlg('Cancer is present')
      end
      pause(1)
   end
fprintf('------------------------------------------------------------------\n');





