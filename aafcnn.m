function a=aafcnn(z, af, dir, err)

if dir==1000
    a=ones(size(z));
else
if af=='sigm'
    a=1./(1+exp(-z));
    if dir ==1
        a = z.* (1-z);
        a = a.*err;
    end
elseif af == 'tanh'

      a = tanh(z);
      if dir ==1
          a = 1-z.*z;
          a = a.*err;
      end
elseif af == 'rect' 
    leak = 0.01;

      a = z .* (leak + (1 - leak) * (z > 0)) ;
      if dir ==1
          a = (leak + (1 - leak) * (z > 0)) ;
          a= a.*err;
      end 
elseif af == 'none'
    a=z;
    if dir ==1
        a = z.*err;
    end
elseif af == 'soft' 
    a= exp(z);
    a = (a)./repmat(sum(a,1), [size(z,1) 1]);
    if dir ==1

        err1 = repmat(sum(err.*z, 1), [size(err,1) 1]);
        a = -z.* (err1 -err);
    end
elseif af == 'plus'  
    checkvalues(z)
    a = log(1+exp(z));
    checkvalues(a, z)
    if dir==1
         a=1 - exp(-z);
         a = a.*err;
    end
else
    error ''
end

end