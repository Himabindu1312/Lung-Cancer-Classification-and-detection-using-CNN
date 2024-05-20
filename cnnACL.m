function cnn=cnnACL(cnn, nof, sok, afn)
cnn.nol= cnn.nol +1;
l=cnn.nol;
cnn.ly{l}.type = 'c';
cnn.ly{l}.no_fm = nof;
cnn.ly{l}.kw= sok(1);
cnn.ly{l}.kh= sok(1);
if numel(sok)==2
    cnn.ly{l}.kw= sok(2);
end
prev_layer_fm_width=cnn.iiw;
prev_layer_fm_height=cnn.iih;
prev_layer_no_fm = cnn.noic;
if l>1
    prev_layer_no_fm = cnn.ly{l-1}.no_fm;
    prev_layer_fm_width = cnn.ly{l-1}.fm_width;
    prev_layer_fm_height = cnn.ly{l-1}.fm_height;
end

cnn.ly{l}.fm_width = prev_layer_fm_width - cnn.ly{l}.kw +1;
cnn.ly{l}.fm_height = prev_layer_fm_height - cnn.ly{l}.kh +1;
cnn.ly{l}.prev_layer_no_fm = prev_layer_no_fm;
k=0;
for i=1: nof
    for j=1: prev_layer_no_fm
         k = k+1;       
        cnn.ly{l}.K(:,:,k)= 0.5*rand(cnn.ly{l}.kh,cnn.ly{l}.kw)-0.25;
    end
end
for j=1:nof
     cnn.ly{l}.b(j)=0;
end


cnn.ly{l}.af=afn;
    

    
