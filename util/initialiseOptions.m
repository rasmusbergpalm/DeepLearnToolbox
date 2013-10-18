function opts = initialiseOptions()
#This function initalises the options to normaly useful values so that one does
#not need to do this all the time by hand.

    opts.alpha = 1; #Learning Rate; will be multiplied to the gradient befor applying it
    opts.batchsize = 100; #Take a mean gradient step over this many samples.
    opts.ddhist = 0.5; #Currently used only in CAE.
    opts.ddinterval = 10; #Recalculate double grads every opts.ddinterval.
                          #Currently used only in CAE.
    opts.gibbsSamplingSteps = 1; #Perform this many gibbs sampling steps before
                                 #calculating activation statistics.
                                 #Currently used only in DBN.
    opts.momentum = 0; #momentum term for gradient descent.
    opts.numepochs = 1; #Specifies, how often the weights are updated.
                        #If numepochs <= 0, weights are updated until the error
                        #change falls below opts.threshold.
    opts.plot = 1; #enables and disables plotting
    opts.rounds = 1000;
    opts.threshold = 0.01; #If opts.numepochs <= 0, weights are updated until
                           #the error change falls below opts.threshold.
    opts.validation = 0; #Use validation data instead of training data to compute errors.
    opts.verbosity = 1; #Control amount of status informations.
end#function
