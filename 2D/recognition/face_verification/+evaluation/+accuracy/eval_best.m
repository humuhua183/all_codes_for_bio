%  Copyright (c) 2014, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

function [res, extra] = eval_best(config, scores, gt, interval)
    
if nargin==3
  interval = 1;
end
    % finds an optimal threshold - the threshold which maximises the accuracy

    % threshold scores and get the sign
    gt(gt==0)=-1;
    res = -Inf;
    extra.bestThresh = [];
    
    % thresh loop
    for i=1:interval:numel(scores)
         
        curThresh = scores(i);
        class = 2 * (scores >= curThresh) - 1;
        
        % class-n accuracy
        acc = mean(class == gt);
        
        if acc > res
            
            res = acc;
            extra.bestThresh = curThresh;            
        end
    end
    
    res = res * 100;
    
end
