function cnn=BaPrcnn(cnn,yy)

if cnn.ly{cnn.nol}.type ~= 'f'
  zz=[];
  for k=1:cnn.ly{cnn.nol}.no_fm
                   ss =size(cnn.ly{cnn.nol}.fm{k});
                   zz =[zz; reshape(cnn.ly{cnn.nol}.fm{k}, ss(1)*ss(2), ss(3))];
  end
   cnn.ly{cnn.nol}.outputs = zz;
end
 er = ( cnn.ly{cnn.nol}.outputs - yy);
 
if cnn.lf == 'cros' 
    if cnn.ly{cnn.nol}.af == 'sigm'
        er1 = -1.*sum((yy.*log(cnn.ly{cnn.nol}.outputs) + (1-yy).*log(1-cnn.ly{cnn.nol}.outputs)), 1);
    else

          error('');
          
          
          
    end
    cnn.loss = sum(er1(:))/size(er1,2); 

else
    er1 = er.^2;
    cnn.loss = sum(er1(:))/(2*size(er1,2)); 
     
end

if cnn.CLLAD ==1 
    er =aafccnn(cnn.ly{cnn.nol}.outputs,cnn.ly{cnn.nol}.af, 1, er);
end



if cnn.ly{cnn.nol}.type == 'f'
       cnn.ly{cnn.nol}.er{1} =er; 
       cnn.ly{cnn.nol}.dW = cnn.ly{cnn.nol}.er{1} * ( cnn.ly{cnn.nol-1}.outputs)' / size(cnn.ly{cnn.nol}.er{1}, 2);
       cnn.ly{cnn.nol}.db = mean( cnn.ly{cnn.nol}.er{1}, 2);
elseif cnn.ly{cnn.nol}.type == 'p'
    sz2=0;
    for i=1:cnn.ly{cnn.nol}.no_fm
        sz = size(cnn.ly{cnn.nol}.fm{i});
        sz1 = sz(1)*sz(2);
        cnn.ly{cnn.nol}.er{i} = reshape(er(sz2+1 : sz2+sz1, : ), sz(1), sz(2), sz(3));
        sz2 = sz2+sz1;
    end
    
    zz=cnn.ly{cnn.nol}.ssr;
    if cnn.ly{cnn.nol}.ssm == 'mean'
        for i=1:cnn.ly{cnn.nol}.no_fm
            sz = size(cnn.ly{cnn.nol}.fm{i});
            ss1 = 1:sz(1); ss1 =kron(ss1, ones([1 zz]));
            ss2 = 1:sz(2); ss2 =kron(ss2, ones([1 zz]));
            sf{1}=ss1; sf{2}=ss2;
            er =cnn.ly{cnn.nol}.er{i};
            new_er = er(sf{:},:);
            cnn.ly{cnn.nol}.er{i} = new_er; % kron( cnn.ly{cnn.nol}.er{i}, ones([zz zz]));
        end

    else
        error '';
    end
elseif cnn.ly{cnn.nol}.type == 'c'
     sz2=0;
    for i=1:cnn.ly{cnn.nol}.no_fm
        sz = size(cnn.ly{cnn.nol}.fm{i});
        sz1 = sz(1)*sz(2);
        cnn.ly{cnn.nol}.er{i} = reshape(er(sz2+1 : sz2+sz1, : ), sz(1), sz(2), sz(3));
        sz2 = sz2+sz1;
    end
    kk=0;
    for i=1:cnn.ly{cnn.nol}.no_fm
        for j=1:cnn.ly{cnn.nol-1}.no_fm
            zz= convn(cnn.ly{cnn.nol-1}.fm{j}, rot90(cnn.ly{cnn.nol}.er{i},2), 'valid');
            kk = kk+1;
            cnn.ly{cnn.nol}.dK(:,:,kk) = mean(zz,3);
        end
        cnn.ly{cnn.nol}.db(i)= sum(cnn.ly{cnn.nol}.er{i}(:))/size(cnn.ly{cnn.nol}.er{i},3);
    end
    
end


for i=cnn.nol-1:-1:1
    
    if cnn.ly{i}.type == 'f'
       cnn.ly{i}.er{1} = ( (cnn.ly{i+1}.W)' * cnn.ly{i+1}.er{1} );
       cnn.ly{i}.er{1} = aafcnn(cnn.ly{i}.outputs,cnn.ly{i}.af, 1, cnn.ly{i}.er{1} ); 
       cnn.ly{i}.dW = cnn.ly{i}.er{1} * ( cnn.ly{i-1}.outputs)' / size(cnn.ly{i}.er{1}, 2);
       cnn.ly{i}.db = mean( cnn.ly{i}.er{1}, 2);
    elseif cnn.ly{i}.type == 'p'
           cnn.ly{i}.er{1}= 0;
           if cnn.ly{i+1}.type == 'f'
                sz2=0;
                er = ( (cnn.ly{i+1}.W)' * cnn.ly{i+1}.er{1} );
                for j=1:cnn.ly{i}.no_fm
                    sz = size(cnn.ly{i}.fm{j});
                    sz1 = sz(1)*sz(2);
                    cnn.ly{i}.er{j} = reshape(er(sz2+1 : sz2+sz1, : ), sz(1), sz(2), sz(3));
                    sz2 = sz2+sz1;
                end
           elseif cnn.ly{i+1}.type == 'c'
               er =cnn.ly{i+1}.er;
               for k=1:cnn.ly{i}.no_fm
                   cnn.ly{i}.er{k}=zeros(size(cnn.ly{i}.fm{k}));
               end
               kk=0;
               for j=1:cnn.ly{i+1}.no_fm
                   for k=1:cnn.ly{i}.no_fm
                       kk = kk+1;
                      cnn.ly{i}.er{k} = cnn.ly{i}.er{k} + convn(er{j}, rot90(cnn.ly{i+1}.K(:,:,kk),2), 'full'); 
                   end
               end
           else
               er =cnn.ly{i+1}.er;
               cnn.ly{i}.er =er;
           end
           
           zz=cnn.ly{i}.ssr;
            if cnn.ly{i}.ssm == 'mean'
                 for j=1:cnn.ly{i}.no_fm
                    sz = size(cnn.ly{i}.fm{j});
                    ss1 = 1:sz(1); ss1 =kron(ss1, ones([1 zz]));
                    ss2 = 1:sz(2); ss2 =kron(ss2, ones([1 zz]));
                    sf{1}=ss1; sf{2}=ss2;
                    er =cnn.ly{i}.er{j};
                    new_er = er(sf{:},:);
                    cnn.ly{i}.er{j} = new_er./(zz*zz); 
                 end

            else
                error '';
            end
            
    elseif cnn.ly{i}.type == 'c'
          er =0;
         cnn.ly{i}.er{1}= 0;
           if cnn.ly{i+1}.type == 'f'
                sz2=0;
                er1 = ( (cnn.ly{i+1}.W)' * cnn.ly{i+1}.er{1} );
                for j=1:cnn.ly{i}.no_fm
                    sz = size(cnn.ly{i}.fm{j});
                    sz1 = sz(1)*sz(2);
                    cnn.ly{i}.er{j} = reshape(er1(sz2+1 : sz2+sz1, : ), sz(1), sz(2), sz(3));
                    sz2 = sz2+sz1;
                end
                er = cnn.ly{i}.er;
           elseif cnn.ly{i+1}.type == 'c'
               error('');
           else
               er =cnn.ly{i+1}.er;
           end
           if cnn.ly{i}.af == 'soft'

                 err1 = zeros(size(er{1}));
                 for j=1:cnn.ly{i}.no_fm
                     err1 = err1 + er{j}.*cnn.ly{i}.fm{j};
                 end
                 for j=1:cnn.ly{i}.no_fm
                     cnn.ly{i}.er{j} = cnn.ly{i}.fm{j}.*(er{j} - err1);
                 end
           else
                   for j=1:cnn.ly{i}.no_fm
                       cnn.ly{i}.er{j} =aafcnn(cnn.ly{i}.fm{j},cnn.ly{i}.af, 1, er{j});
                   end
           end
              
           
           
           kk=0;
            for ii=1:cnn.ly{i}.no_fm
                for j=1:cnn.ly{i-1}.no_fm
                   zz= convn(cnn.ly{i-1}.fm{j},flipdim(flipdim(flipdim(cnn.ly{i}.er{ii},1),2),3), 'valid'); %

                    kk = kk+1;
                    cnn.ly{i}.dK(:,:,kk) = zz./size(cnn.ly{i}.er{ii},3); 
                end
                cnn.ly{i}.db(ii)= sum(cnn.ly{i}.er{ii}(:))/size(cnn.ly{i}.er{ii},3);
            end
        
    end
    
end