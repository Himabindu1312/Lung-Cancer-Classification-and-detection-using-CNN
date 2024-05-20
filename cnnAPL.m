function cnn=cnnAPL(cnn, ssr, ssm)

cnn.nol= cnn.nol +1;
l=cnn.nol;
cnn.ly{l}.type = 'p';
cnn.ly{l}.ssr=ssr;
cnn.ly{l}.ssm=ssm;
cnn.ly{l}.no_fm = cnn.ly{l-1}.no_fm;
cnn.ly{l}.fm_width = cnn.ly{l-1}.fm_width/ssr;
cnn.ly{l}.fm_height = cnn.ly{l-1}.fm_height/ssr;
    
cnn.ly{l}.act_func='none';
    
