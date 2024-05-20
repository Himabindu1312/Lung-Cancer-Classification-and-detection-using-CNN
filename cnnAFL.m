function cnn=cnnAFL(cnn, non, af)

cnn.nol= cnn.nol +1;
l=cnn.nol;
cnn.ly{l}.type = 'f';
cnn.ly{l}.non=non;
cnn.ly{l}.af=af;

plfw=cnn.iiw;
plfh=cnn.iih;
plnf = cnn.noic;
cnn.ly{l}.noi = plnf * plfh *plfw;
cnn.ly{l}.citID=1;
if l>1 & cnn.ly{l-1}.type ~= 'f'
    plnf = cnn.ly{l-1}.no_fm;
    plfw = cnn.ly{l-1}.fm_width;
    plfh = cnn.ly{l-1}.fm_height;
    cnn.ly{l}.noi = plnf * plfh *plfw;
    cnn.ly{l}.citID=1;
elseif l>1 & cnn.ly{l-1}.type == 'f'
    cnn.ly{l}.noi = cnn.ly{l-1}.non;
    cnn.ly{l}.citID=0; 
end
cnn.ly{l}.W =0.5*rand([non cnn.ly{l}.noi]) -0.25;
cnn.ly{l}.b = 0.5*rand([non 1]) - 0.25;

    

    
