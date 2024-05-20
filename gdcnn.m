function cnn=gdcnn(cnn)

for i=2:cnn.nol
    
   if cnn.ly{i}.type == 'f'
       cnn.ly{i}.W = cnn.ly{i}.W - cnn.lr*( cnn.ly{i}.dW );
       cnn.ly{i}.b = cnn.ly{i}.b - cnn.lr*( cnn.ly{i}.db );
   elseif cnn.ly{i}.type == 'c'
       kk=0;
       for j=1:cnn.ly{i}.no_fm
            for k=1:cnn.ly{i-1}.no_fm
                kk = kk +1;
                cnn.ly{i}.K(:,:,kk)= cnn.ly{i}.K(:,:,kk) -  cnn.lr*( cnn.ly{i}.dK(:,:,kk) );
            end
            cnn.ly{i}.b(j) = cnn.ly{i}.b(j) -  cnn.lr*(cnn.ly{i}.db(j) );
       end
       
   end
   
end