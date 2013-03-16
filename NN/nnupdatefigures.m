function nnupdatefigures(nn,fhandle,L,opts,i)
%NNUPDATEFIGURES updates figures during training
if i > 1 %dont plot first point, its only a point   
    x_ax = 1:i;
    
    %create data for plots
    plot_x       = x_ax';
    plot_ye      = L.train.e';
    if strcmp(nn.output,'softmax')
        plot_yfrac   = L.train.e_frac';
    end
    
    % create legend 
    M            = {'Training'};
    % add error on validation data if present
    if opts.validation == 1
        M            = {'Training','Validation'};
        plot_x       = [plot_x, x_ax'];
        plot_ye      = [plot_ye,L.val.e'];
    end
    
    %add classification error on validation data if present
    if opts.validation == 1 && strcmp(nn.output,'softmax')
        plot_yfrac   = [plot_yfrac, L.val.e_frac'];        
    end
    
%    plotting
    figure(fhandle);   
    p1 = subplot(1,2,1);
        plot(plot_x,plot_ye);
        xlabel('Number of epochs'); ylabel('Error');title('Error');
        legend(p1, M,'Location','NorthEast');
        set(p1, 'Xlim',[0,opts.numepochs + 1])
        
        if i ==2 % speeds up plotting by factor of ~2
            set(gca,'LegendColorbarListeners',[]);
            setappdata(gca,'LegendColorbarManualSpace',1);
            setappdata(gca,'LegendColorbarReclaimSpace',1);
        end
        
    if strcmp(nn.output,'softmax')  %also plot classification error              
        p2 = subplot(1,2,2);
        plot(plot_x,plot_yfrac);
        xlabel('Number of epochs'); ylabel('Misclassification rate');
        title('Misclassification rate')
        legend(p2, M,'Location','NorthEast');
        set(p2, 'Xlim',[0,opts.numepochs + 1])
    end
    drawnow;
end
end