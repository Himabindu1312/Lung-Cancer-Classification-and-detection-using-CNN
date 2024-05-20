function cnn=It_cnn(cnn, soi)


cnn.iih = soi(1);
cnn.iiw = soi(2);
cnn.noic=1;
if numel(soi) == 3
  cnn.noic=soi(3);
end
cnn.nol=1;
cnn.ly{1} =struct('type', 'i', 'no_fm', cnn.noic);
cnn.ly{1}.type = 'i'; %input layer
cnn.ly{1}.no_fm = cnn.noic;
cnn.ly{1}.fm_width = cnn.iiw;
cnn.ly{1}.fm_height =cnn.iih ;
cnn.ly{1}.prev_layer_no_fm = 0;


cnn.lf='auto'; 
cnn.rc = 0;
cnn.lr = 0.01;
