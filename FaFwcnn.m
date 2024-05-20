function cnn=FaFwcnn(cnn, xx)

if cnn.noic > 1
    for i=1:cnn.noic 
        cnn.ly{1}.fm{i}=xx(:,:,i,:);
    end
else
    cnn.ly{1}.fm{1}=xx;
end
for i=2:cnn.nol
    
    if cnn.ly{i}.type == 'c'
        kk=0;
        zz=0;
        for j=1:cnn.ly{i}.no_fm
            z = 0; 
            for k=1:cnn.ly{i-1}.no_fm
                kk = kk +1;
                z = z + convn(cnn.ly{i-1}.fm{k},rot90(cnn.ly{i}.K(:,:,kk),2),'valid'); %cnn.ly{i}.K(:,:,kk),'valid');%rot90(cnn.ly{i}.K(:,:,kk),2),'valid');

            end
            if cnn.ly{i}.af == 'soft'
                cnn.ly{i}.fm{j}= exp(z + cnn.ly{i}.b(j));
                zz = zz + cnn.ly{i}.fm{j};
            else
                cnn.ly{i}.fm{j} = aafcnn(z+ cnn.ly{i}.b(j),cnn.ly{i}.af, 0);

            end
        end
        if cnn.ly{i}.af == 'soft'
            for j=1:cnn.ly{i}.no_fm
                cnn.ly{i}.fm{j}= cnn.ly{i}.fm{j} ./ zz;
            end
        end
    elseif cnn.ly{i}.type == 'p'
        
            if cnn.ly{i}.ssm == 'mean'
                h = ones([cnn.ly{i}.ssr cnn.ly{i}.ssr]); h=h./sum(h(:));
                for k=1:cnn.ly{i-1}.no_fm
                    zz = convn(cnn.ly{i-1}.fm{k}, h, 'valid'); %%'same'
                    cnn.ly{i}.fm{k} = zz(1:cnn.ly{i}.ssr:end, 1:cnn.ly{i}.ssr:end,:);

                end
            elseif cnn.ly{i}.ssm == 'max '
                error ''

            end
    elseif cnn.ly{i}.type == 'f'
            zz=0;
            zz=[];
            if cnn.ly{i-1}.type  ~= 'f'
                for k=1:cnn.ly{i-1}.no_fm
                   ss =size(cnn.ly{i-1}.fm{k});
                   ss(3) =size(cnn.ly{i-1}.fm{k},3);
                   if cnn.iiw == 1
                       ss(3) =ss(2);
                       ss(2)=1;
                   end
                   zz =[zz; reshape(cnn.ly{i-1}.fm{k}, ss(1)*ss(2), ss(3))];
                   
                end
                cnn.ly{i-1}.outputs = zz;
                cnn.ly{i}.outputs = aafcnn(cnn.ly{i}.W*zz + repmat(cnn.ly{i}.b, 1, size(zz,2)), cnn.ly{i}.af, 0); 
                
            else
                zz= cnn.ly{i-1}.outputs;
                cnn.ly{i}.outputs = aafcnn(cnn.ly{i}.W*zz + repmat(cnn.ly{i}.b, 1, size(zz,2)), cnn.ly{i}.af, 0); 
            end
                
        
    end
    
end