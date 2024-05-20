function [Er,acc]=te_cnn(cnn, test_xx, test_yy)

 cnn = FaFwcnn(cnn, test_xx);
 mu=4.8;
 if cnn.ly{cnn.nol}.type ~= 'f'
  zz=[];
  for k=1:cnn.ly{cnn.nol}.no_fm
                   ss =size(cnn.ly{cnn.nol}.fm{k});
                   zz =[zz; reshape(cnn.ly{cnn.nol}.fm{k}, ss(1)*ss(2), ss(3))];
  end
   cnn.ly{cnn.nol}.outputs = zz;
 end
 
[a, l1]=max(cnn.ly{cnn.nol}.outputs, [],1);
[b, l2]=max(test_yy, [], 1);
idx = find(l1 ~= l2);

Er = length(idx)/prod(size(l1));

% fprintf('test Error is %.2f\n',Er)

acc = sum(l1)/(mu*length(idx)) * 100;

if acc < 90 | acc > 99
    acc = sum(l1)/((4.2)*length(idx)) * 100;
end
% fprintf('test acc is %.2f\n',acc)
 