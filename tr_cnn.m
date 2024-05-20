function cnn=tr_cnn(cnn,x,y, noe,bs)

m=1;
m_idx=1;
if size(x,4) > 1 
    m=size(x,4);
    m_idx=4; 
else
    m=size(x,3);
    m_idx=3;
end
nob = m/bs; 
if rem(m, bs) ~=0
    error('nob should be integer');
end

if cnn.lf == 'auto'
   cnn.lf = 'quad'; 
   if cnn.ly{cnn.nol}.af == 'sigm'
       cnn.lf = 'cros' ; 
   elseif cnn.ly{cnn.nol}.af == 'tanh'
       cnn.lf = 'quad';
   
       
   end
elseif strcmp(cnn.lf, 'cros') == 1 & strcmp(cnn.ly{cnn.nol}.af, 'sigm') == 0
    display ''
end

cnn.CLLAD =1;
if cnn.lf == 'cros' 
    if cnn.ly{cnn.nol}.af == 'soft'
        cnn.CLLAD =0;
    elseif cnn.ly{cnn.nol}.af == 'sigm'
        cnn.CLLAD =0;
    end    
end

if cnn.ly{cnn.nol}.af == 'none'
    cnn.CLLAD =0;
end

display 'training started...'
cnn.la=[];
for i=1:noe
    tic
    for j=1:bs:m
        if m_idx==4
            xx = x(:,:,:,j:j+bs-1);
        else
            xx = x(:,:,j:j+bs-1);
        end
        yy =y(:,j:j+bs-1);
        cnn=FaFwcnn(cnn, xx);
        cnn = BaPrcnn(cnn,yy);
        cnn =gdcnn(cnn);
        
        cnn.la = [cnn.la cnn.loss];
        
    end
    toc
end
% figure
% stairs(1:noe*nob, cnn.la)
% xlabel('Number of epochs'),ylabel('Loss')