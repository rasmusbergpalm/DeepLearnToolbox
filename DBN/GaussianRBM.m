%{
===========================================================================
Code provided by Yichuan (Charlie) Tang 
http://www.cs.toronto.edu/~tang

Permission is granted for anyone to copy, use, modify, or distribute this
program and accompanying programs and documents for any purpose, provided
this copyright notice is retained and prominently displayed, along with
a note saying that the original programs are available from our
web page.
The programs and documents are distributed without any warranty, express or
implied.  As the programs were written for research purposes only, they 
have not been tested to the degree that would be advisable in any important
application.  All use of these programs is entirely at the user's own risk.
===========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dbn_rbm_vng_learn_v_var
Based on code provided by Geoff Hinton and Ruslan Salakhutdinov.
http://www.cs.toronto.edu/~hinton/MatlabForSciencePaper.html

CT 3/2011
PURPOSE: To train a RBM with visible nodes gaussian, but also learns the 
         variance as well
INPUT:  
OUTPUT: 
NOTES:  
TESTED:
CHANGELOG:
TODO:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}

function [vhW, vb, hb, fvar, errs] = GaussianRBM(batchdata, params)

[n d nBatches]=size(batchdata);

assert(params.v_var > 0);
fstd = ones(1,d)*sqrt(params.v_var);
params.v_var=[];

r = params.epislonw_vng;

std_rate = linspace(0, params.std_rate, params.maxepoch);
std_rate(:) = params.std_rate;
std_rate(1:min(30, params.maxepoch/2)) = 0; %learning schedule for variances


assert( all(size(params.PreWts.vhW) == [d params.nHidNodes]));
assert( all(size(params.PreWts.hb) == [1 params.nHidNodes]));
assert( all(size(params.PreWts.vb) == [1 d]));

vhW = params.PreWts.vhW;
vb = params.PreWts.vb;
hb = params.PreWts.hb;

vhWInc  = zeros( d, params.nHidNodes);
hbInc   = zeros( 1, params.nHidNodes);
vbInc   = zeros( 1, d);
invfstdInc = zeros(1,d);

Ones = ones(n,1);

q=zeros(1, params.nHidNodes); %keep track of average activations
errs =  zeros(1, params.maxepoch);

fprintf('\rTraining Learning v_var Gaussian-Binary RBM %d-%d   epochs:%d r:%f',...
    d, params.nHidNodes, params.maxepoch, r);
for epoch = 1:params.maxepoch
  
    if rem(epoch, int32(params.maxepoch/20)) == 0 || epoch < 30
        fprintf('\repoch %d',epoch);
    end
    
    errsum=0;
    ptot = 0;
    for batch = 1:nBatches
        
        Fstd = Ones*fstd;
        
        %%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        data = batchdata(:,:,batch); %nxd     
        pos_hidprobs = 1./(1 + exp(-(data./Fstd)*vhW - Ones*hb)); %p(h_j =1|data)        
        pos_hidstates = pos_hidprobs > rand( size(pos_hidprobs) );
                
        pos_prods    = (data./Fstd)'* pos_hidprobs;
        pos_hid_act  = sum(pos_hidprobs);
        pos_vis_act  = sum(data)./(fstd.^2); %see notes on this derivation
               
        %%%%%%%%% END OF POSITIVE PHASE %%%%%%%%%
        for iterCD = 1:params.nCD
            
            %%%%%%%%% START NEGATIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            negdataprobs = pos_hidstates*vhW'.*Fstd+Ones*vb;
            negdata = negdataprobs + randn(n, d).*Fstd;
            neg_hidprobs = 1./(1 + exp(-(negdata./Fstd)*vhW - Ones*hb ));     %updating hidden nodes again
            pos_hidstates = neg_hidprobs > rand( size(neg_hidprobs) );
            
        end %end CD iterations
       
        neg_prods  = (negdata./Fstd)'*neg_hidprobs;
        neg_hid_act = sum(neg_hidprobs);
        neg_vis_act = sum(negdata)./(fstd.^2); %see notes for details
        
        %%%%%%%%% END OF NEGATIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
               
        errsum = errsum + sum(sum( (data-negdata).^2 ));
        
%         if epoch>1
%             if  errs(epoch-1)<errsum
%                 error('Error increase, epcoh %d\n',epoch);
%             end
%         end
       
      if exist('params.momen_grad')        
        if epoch > params.init_final_momen_iter,
            momentum=params.final_momen;
        else
            momentum=params.init_momen;
        end
      else
          momentum=params.momen_grad(epoch);
      end
        
        %%%%%%%%% UPDATE WEIGHTS AND BIASES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        vhWInc = momentum*vhWInc + r/n*(pos_prods-neg_prods) - r*params.wtcost*vhW;
        vbInc = momentum*vbInc + (r/n)*(pos_vis_act-neg_vis_act);
        hbInc = momentum*hbInc + (r/n)*(pos_hid_act-neg_hid_act);
        
        invfstd_grad = sum(2*data.*(Ones*vb-data/2)./Fstd,1) + sum(data' .* (vhW*pos_hidprobs') ,2)';
        invfstd_grad = invfstd_grad - ( sum(2*negdata.*(Ones*vb-negdata/2)./Fstd,1) + ...
                                sum( negdata'.*(vhW*neg_hidprobs') ,2 )' );
                            
        invfstdInc = momentum*invfstdInc + std_rate(epoch)/n*invfstd_grad;
               
        if params.SPARSE == 1 %nair's paper on 3D object recognition            
            %update q
            if batch==1 && epoch == 1
                q = mean(pos_hidprobs);
            else
                q_prev = q;
                q = 0.9*q_prev+0.1*mean(pos_hidprobs);
            end           
           
            p = params.sparse_p;
            grad = 0.1*params.sparse_lambda/n*sum(pos_hidprobs.*(1-pos_hidprobs)).*(p-q)./(q.*(1-q));
            gradW =0.1*params.sparse_lambda/n*(data'./Fstd'*(pos_hidprobs.*(1-pos_hidprobs))).*repmat((p-q)./(q.*(1-q)), d,1);
            
            hbInc = hbInc + r*grad;
            vhWInc = vhWInc + r*gradW;
        end
        
        ptot = ptot+mean(pos_hidprobs(:));
        
        vhW = vhW + vhWInc;
        vb = vb + vbInc;
        hb = hb + hbInc;    
        
        invfstd = 1./fstd;
        invfstd =  invfstd + invfstdInc;
        fstd = 1./invfstd;

        fstd = max(fstd, 0.005); %have a lower bound!        
        %%%%%%%%%%%%%%%% END OF UPDATES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    end

    if rem(epoch, int32(params.maxepoch/20)) == 0 || epoch < 30
        fprintf(1, ' p%1.2f  ',  ptot/nBatches );
        fprintf(1, ' error %6.2f  mm:%.2f ', errsum,  momentum);
        fprintf(1, 'vh_W min %2.4f   max %2.4f ', min(min(vhW)), max(max(vhW)));
    end
    errs(epoch) = errsum;    
end
fvar = fstd.^2;

