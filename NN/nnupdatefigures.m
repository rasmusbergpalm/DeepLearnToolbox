function nnupdatefigures(nn,fhandle,L,opts,i)
%NNUPDATEFIGURES updates figures during training
if i > 1 %dont plot first point, its only a point   
    x_ax = 1:i;
    % create legend
    if opts.validation == 1
        M            = {'Training','Validation'};
    else
        M            = {'Training'};
    end
    
    %create data for plots
    if strcmp(nn.output,'softmax')
        plot_x       = x_ax';
        plot_ye      = L.train.e';
        plot_yfrac   = L.train.e_frac';
        
    else
        plot_x       = x_ax';
        plot_ye      = L.train.e';
    end
    
    %add error on validation data if present
    if opts.validation == 1
        plot_x       = [plot_x, x_ax'];
        plot_ye      = [plot_ye,L.val.e'];
    end
    
    
    %add classification error on validation data if present
    if opts.validation == 1 && strcmp(nn.output,'softmax')
        plot_yfrac   = [plot_yfrac, L.val.e_frac'];        
    end
    
%    plotting
    figure(fhandle);   
    if strcmp(nn.output,'softmax')  %also plot classification error
                
        p1 = subplot(1,2,1);
        plot(plot_x,plot_ye);
        xlabel('Number of epochs'); ylabel('Error');title('Error');
        title('Error')
        legend(p1, M,'Location','NorthEast');
        set(p1, 'Xlim',[0,opts.numepochs + 1])
        
        p2 = subplot(1,2,2);
        plot(plot_x,plot_yfrac);
        xlabel('Number of epochs'); ylabel('Misclassification rate');
        title('Misclassification rate')
        legend(p2, M,'Location','NorthEast');
        set(p2, 'Xlim',[0,opts.numepochs + 1])
        
    else
        
        p = plot(plot_x,plot_ye);
        xlabel('Number of epochs'); ylabel('Error');title('Error');
        legend(p, M,'Location','NorthEast');
        set(gca, 'Xlim',[0,opts.numepochs + 1])
                
    end
    drawnow;
end
end
